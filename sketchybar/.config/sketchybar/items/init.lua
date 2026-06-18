local colors = require("colors")

-- ══════════════════════════════════════════════════════════════
-- 【動的取得】内蔵ディスプレイの有無とインデックス番号を特定する
-- ══════════════════════════════════════════════════════════════
-- has_builtin が false の場合 = クラムシェルモード等で内蔵が検出できない
-- （蓋を閉じている場合、system_profiler の出力に "Built-In" 自体が現れない機種が多い）
local builtin_display = nil
local has_builtin = false

local builtin_cmd =
	"system_profiler SPDisplaysDataType | awk '/Display Type:/ {i++} /Built-In/ {print i; f=1} END{if(!f) print \"NONE\"}'"
local builtin_handle = io.popen(builtin_cmd)
if builtin_handle then
	local result = builtin_handle:read("*a")
	builtin_handle:close()
	if not result:match("NONE") then
		local num = tonumber(result:match("%d+"))
		if num then
			builtin_display = num
			has_builtin = true
		end
	end
end

-- 接続されているディスプレイの総数を取得（"Resolution:" の出現回数で判定）
local total_displays = 1
local count_handle = io.popen("system_profiler SPDisplaysDataType | grep -c 'Resolution:'")
if count_handle then
	total_displays = tonumber(count_handle:read("*a")) or 1
	count_handle:close()
end

-- 内蔵が存在し、かつ台数が2以上 → 外部ディスプレイも接続されている
local has_external = has_builtin and (total_displays > 1)

-- 外部モニター用の条件式（内蔵が存在する場合のみ意味を持つ）
local external_display = nil
if has_builtin then
	external_display = ">" .. builtin_display
	if builtin_display > 1 then
		external_display = "not " .. builtin_display
	end
end

-- ──────────────────────────── LEFT ────────────────────────────
require("items.apple")
require("items.spaces")
-- require("items.front_apps")

-- ──────────────── CENTER — LEFT of notch ──────────────────────
require("items.media")

-- ══════════════════════════════════════════════════════════════
-- 【動的取得】モデル × 論理解像度でノッチ幅を自動算出
-- （内蔵ディスプレイが存在しない場合はこの処理自体をスキップする）
-- ══════════════════════════════════════════════════════════════
local notch_width = 250 -- フォールバック

if has_builtin then
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

	local spec = MODELS[model_id]
	if spec and logical_width > 0 then
		-- スケールファクタ = 物理幅 ÷ 論理幅
		local scale = spec.phys_w / logical_width
		-- SketchyBarの論理pt = 物理ノッチ幅 ÷ スケールファクタ（小数点切り捨て）
		notch_width = math.floor(spec.notch_phys / scale)
	end
end

-- ══════════════════════════════════════════════════════════════
-- ディスプレイ構成に応じたノッチ回避アイテムの配置
--   パターン1: 内蔵 + 外部 両方接続
--   パターン2: 内蔵のみ
--   パターン3: 外部のみ（内蔵が検出できない = クラムシェルモード等）
-- ══════════════════════════════════════════════════════════════
if has_builtin and has_external then
	-- ── パターン1: 内蔵 + 外部 ──────────────────────────────
	-- 内蔵側はモデル別に算出したノッチ幅でスペーサーを配置
	sbar.add("item", "center.notch", {
		position = "center",
		display = builtin_display,
		width = notch_width,
		icon = { drawing = false },
		label = { drawing = false },
		background = { color = colors.transparent },
	})

	-- 外部モニター側は見た目を揃えるための固定の余白のみ
	sbar.add("item", "center.external_gap", {
		position = "center",
		display = external_display,
		width = 20,
		icon = { drawing = false },
		label = { drawing = false },
		background = { color = colors.transparent },
	})
elseif has_builtin and not has_external then
	-- ── パターン2: 内蔵のみ ──────────────────────────────────
	-- 外部がないので center.external_gap は作成しない
	sbar.add("item", "center.notch", {
		position = "center",
		display = builtin_display,
		width = notch_width,
		icon = { drawing = false },
		label = { drawing = false },
		background = { color = colors.transparent },
	})
else
	-- ── パターン3: 外部のみ（内蔵が検出できない） ────────────
	-- 物理ノッチが存在しないので、幅0のダミーアイテムのみ配置する。
	-- ("center.notch" という名前自体は bracket.media の参照整合性のため残す)
	sbar.add("item", "center.notch", {
		position = "center",
		display = "active",
		width = 0,
		icon = { drawing = false },
		label = { drawing = false },
		background = { color = colors.transparent },
	})
end

-- ─────────────────────────── CENTER - RIGHT of notch ────────────────────────────
require("items.widgets.weather")
require("items.calendar")
-- ─────────────────────────── RIGHT ────────────────────────────
-- require("items.control_center")
require("items.brew")
require("items.widgets.input")
require("items.widgets.battery")
require("items.widgets.bluetooth")
require("items.widgets.cpu")
require("items.widgets.wifi")
require("items.widgets.volume")

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
		height = 28,
		border_width = 1,
	},
})

-- Center notch pill: media — [notch] — time + date
-- The pill background spans both halves; the notch hardware creates the visual gap.
sbar.add("bracket", "bracket.media", {
	"/^center\\.media.*/",
	"center.notch",
	"/^widgets\\.weather.*/",
	"center.time",
	"center.date",
}, {
	background = {
		color = colors.bg5,
		corner_radius = CORNER_RADIUS,
		height = 28,
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
	"brew",
	-- "control_center",
}, {
	background = {
		color = colors.bg5,
		border_color = colors.bg1,
		corner_radius = CORNER_RADIUS,
		height = 28,
		border_width = 1,
	},
})
