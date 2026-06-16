local colors = require("colors")
-- ══════════════════════════════════════════════════════════════
-- 【動的取得】内蔵ディスプレイのインデックス番号を特定する
-- ══════════════════════════════════════════════════════════════
-- デフォルト値を 1 に設定（万が一取得に失敗した際のセーフティ）
local builtin_display = 1

-- system_profiler から Built-in（内蔵）画面のインデックス番号を抽出するコマンド
-- 接続されているディスプレイの中から "Built-in" という文字列がある順番を探します
local cmd = "system_profiler SPDisplaysDataType | awk '/Display Type:/ {i++} /Built-In/ {print i}'"

-- 同期（ブロック）処理として実行し、起動時に確実に番号を特定する
local handle = io.popen(cmd)
if handle then
	local result = handle:read("*a")
	handle:close()
	local num = tonumber(result:match("%d+"))
	if num then
		builtin_display = num
	end
end

-- 外部モニター用の条件式を作成
-- 例: 内蔵が 1 なら 外部は ">1"、内蔵が 2 なら "not 2" のように指定
local external_display = ">" .. builtin_display
if builtin_display > 1 then
	external_display = "not " .. builtin_display
end

-- ──────────────────────────── LEFT ────────────────────────────
require("items.apple")
require("items.spaces")
-- require("items.front_apps")
require("items.media")

-- ──────────────── CENTER — LEFT of notch ──────────────────────
-- ══════════════════════════════════════════════════════════════
-- 【動的取得】モデル × 論理解像度でノッチ幅を自動算出
-- ══════════════════════════════════════════════════════════════

-- モデル識別子を取得（例: "MacBookPro21,3"）
local model_handle = io.popen("sysctl -n hw.model 2>/dev/null")
local model_id = model_handle and model_handle:read("*a"):gsub("%s+", "") or ""
if model_handle then
	model_handle:close()
end

-- 内蔵ディスプレイの論理解像度幅を取得
-- system_profiler は "XXXX x YYYY" 形式で返す
local res_handle = io.popen(
	"system_profiler SPDisplaysDataType" .. " | awk '/Built-In/ {found=1} found && /Resolution/ {print $2; exit}'"
)
local res_raw = res_handle and res_handle:read("*a") or ""
if res_handle then
	res_handle:close()
end
local logical_width = tonumber(res_raw:match("(%d+)")) or 0

-- ──────────────────────────────────────────────
-- ノッチの物理ピクセル幅（機種固定値）
-- ノッチ幅(論理) = 物理幅 ÷ スケールファクタ
--   スケールファクタ = 物理解像度幅 ÷ 論理解像度幅
--
-- 例) MBP 14" (物理3024px, 論理1512px) → スケール2.0
--     ノッチ物理幅 ≒ 420px → 論理 420 ÷ 2.0 = 210pt
-- ──────────────────────────────────────────────
local MODELS = {
	-- ── MacBook Pro 14インチ ──────────────────────────────────
	-- 物理解像度: 3024 × 1964、ノッチ物理幅 ≒ 420px
	-- M1 Pro/Max (2021)
	["Mac18,3"] = { phys_w = 3024, notch_phys = 420 },
	["Mac18,4"] = { phys_w = 3024, notch_phys = 420 },
	-- M2 Pro/Max (2023) ← Mac14,9 はここ
	["Mac14,5"] = { phys_w = 3024, notch_phys = 420 },
	["Mac14,9"] = { phys_w = 3024, notch_phys = 420 },
	-- M3 / M3 Pro / M3 Max (2023)
	["Mac15,3"] = { phys_w = 3024, notch_phys = 420 },
	["Mac15,6"] = { phys_w = 3024, notch_phys = 420 },
	["Mac15,8"] = { phys_w = 3024, notch_phys = 420 },
	["Mac15,10"] = { phys_w = 3024, notch_phys = 420 },
	-- M4 / M4 Pro / M4 Max (2024)
	["Mac16,1"] = { phys_w = 3024, notch_phys = 420 },
	["Mac16,8"] = { phys_w = 3024, notch_phys = 420 },
	["Mac16,6"] = { phys_w = 3024, notch_phys = 420 },

	-- ── MacBook Pro 16インチ ──────────────────────────────────
	-- 物理解像度: 3456 × 2234、ノッチ物理幅 ≒ 460px
	-- M1 Pro/Max (2021)
	["Mac18,1"] = { phys_w = 3456, notch_phys = 460 },
	["Mac18,2"] = { phys_w = 3456, notch_phys = 460 },
	-- M2 Pro/Max (2023)
	["Mac14,6"] = { phys_w = 3456, notch_phys = 460 },
	["Mac14,10"] = { phys_w = 3456, notch_phys = 460 },
	-- M3 Pro/Max (2023)
	["Mac15,7"] = { phys_w = 3456, notch_phys = 460 },
	["Mac15,9"] = { phys_w = 3456, notch_phys = 460 },
	["Mac15,11"] = { phys_w = 3456, notch_phys = 460 },
	-- M4 Pro/Max (2024)
	["Mac16,5"] = { phys_w = 3456, notch_phys = 460 },
	["Mac16,7"] = { phys_w = 3456, notch_phys = 460 },

	-- ── MacBook Air 13インチ ──────────────────────────────────
	-- 物理解像度: 2560 × 1664、ノッチ物理幅 ≒ 310px
	-- M2 (2022)
	["Mac14,2"] = { phys_w = 2560, notch_phys = 310 },
	-- M3 (2024) ← Mac15,12 はここ
	["Mac15,12"] = { phys_w = 2560, notch_phys = 310 },
	-- M4 (2025)
	["Mac16,12"] = { phys_w = 2560, notch_phys = 310 },

	-- ── MacBook Air 15インチ ──────────────────────────────────
	-- 物理解像度: 2880 × 1864、ノッチ物理幅 ≒ 360px
	-- M2 (2023)
	["Mac14,15"] = { phys_w = 2880, notch_phys = 360 },
	-- M3 (2024)
	["Mac15,13"] = { phys_w = 2880, notch_phys = 360 },
	-- M4 (2025)
	["Mac16,13"] = { phys_w = 2880, notch_phys = 360 },
}

local notch_width = 250 -- フォールバック

local spec = MODELS[model_id]
if spec and logical_width > 0 then
	-- スケールファクタ = 物理幅 ÷ 論理幅
	local scale = spec.phys_w / logical_width
	-- SketchyBarの論理pt = 物理ノッチ幅 ÷ スケールファクタ（小数点切り捨て）
	notch_width = math.floor(spec.notch_phys / scale)
end
-- Invisible spacer that covers the MacBook Pro notch.
-- Adjust 'width' if items bleed under the notch:
--   14" MBP default res  → try 200–220
--   16" MBP default res  → try 220–250
-- sbar.add("item", "center.notch", {
-- 	position = "center",
-- 	display = builtin_display,
-- 	width = 220,
-- 	icon = { drawing = false },
-- 	label = { drawing = false },
-- 	background = { color = colors.transparent },
-- })
--
-- ══════════════════════════════════════════════════════════════
-- ディスプレイに応じたノッチ回避アイテムの定義（動的インデックス適用）
-- ══════════════════════════════════════════════════════════════
-- 動的に取得した内蔵ディスプレイにのみ配置
sbar.add("item", "center.notch", {
	position = "center",
	display = builtin_display, -- 【動的】特定された内蔵画面番号
	width = notch_width,
	icon = { drawing = false },
	label = { drawing = false },
	background = { color = colors.transparent },
})

-- 動的に特定された外部モニターにのみ配置
sbar.add("item", "center.external_gap", {
	position = "center",
	display = external_display, -- 【動的】内蔵以外の画面
	width = 20,
	icon = { drawing = false },
	label = { drawing = false },
	background = { color = colors.transparent },
})

-- ──────────────── CENTER — RIGHT of notch ─────────────────────

-- ─────────────────────────── RIGHT ────────────────────────────
require("items.calendar")
require("items.widgets.wifi")
require("items.widgets.input")
require("items.widgets.battery")
require("items.widgets.bluetooth")
require("items.widgets.cpu")
require("items.widgets.volume")
require("items.widgets.weather")
require("items.brew")

-- ══════════════════════════════════════════════════════════════
-- BRACKETS — drawn after all items are created
-- ══════════════════════════════════════════════════════════════

CORNER_RADIUS = 16

-- Left pill: Apple logo + Aerospace workspaces
sbar.add("bracket", "bracket.left", { "apple.logo", "/space\\..*/", "spaces.right_pad", "front_apps" }, {
	background = {
		color = colors.bg5,
		border_color = colors.bg1,
		corner_radius = CORNER_RADIUS,
		-- height = 28,
		border_width = 1,
	},
})

-- Center notch pill: media — [notch] — time + date
-- The pill background spans both halves; the notch hardware creates the visual gap.
sbar.add("bracket", "bracket.media", {
	"center.notch",
	-- "/^center\\.media.*/",
}, {
	background = {
		color = colors.bg5,
		border_color = colors.bg1,
		corner_radius = 4,
		-- height = 24,
		border_width = 1,
	},
})

-- Right pill: WiFi + Bluetooth + Volume + Battery
sbar.add("bracket", "bracket.right", {
	-- "input_source",
	"widgets.cpu",
	"widgets.wifi",
	"widgets.bluetooth",
	"widgets.volume",
	"widgets.battery",
	"widgets.input",
	"items.brew",
	"/^widgets\\.weather.*/",
	"center.date",
	"center.time",
}, {
	background = {
		color = colors.bg5,
		-- corner_radius = CORNER_RADIUS,
		-- height = 28,
		border_width = 1,
	},
})
