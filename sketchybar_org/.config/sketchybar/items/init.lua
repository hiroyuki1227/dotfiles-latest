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

-- ══════════════════════════════════════════════════════════════
-- モジュール（各アイテム）の読み込み
-- ══════════════════════════════════════════════════════════════
require("items.apple")
require("items.spaces")
require("items.front_app")
require("items.media")

-- ══════════════════════════════════════════════════════════════
-- ディスプレイに応じたノッチ回避アイテムの定義（動的インデックス適用）
-- ══════════════════════════════════════════════════════════════
-- 動的に取得した内蔵ディスプレイにのみ配置
sbar.add("item", "center.notch", {
	position = "center",
	display = builtin_display, -- 【動的】特定された内蔵画面番号
	width = 220,
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

-- ══════════════════════════════════════════════════════════════
-- その他のモジュール読み込み
-- ══════════════════════════════════════════════════════════════
require("items.weather")
require("items.calendar")
require("items.widgets.battery")
require("items.widgets.volume")
require("items.widgets.wifi")
require("items.widgets.cpu")
require("items.brew")
require("items.input")

-- ══════════════════════════════════════════════════════════════
-- BRACKETS — 動的ディスプレイ番号の適用
-- ══════════════════════════════════════════════════════════════
CORNER_RADIUS = 16

-- Left pill
-- sbar.add("bracket", "bracket.left", { "apple.logo", "/space\\..*/", "spaces.right_pad" }, {
sbar.add("bracket", "bracket.left", { "apple.logo", "/space\\..*/", "front_app" }, {
	display = "all",
	background = {
		color = colors.bg1,
		corner_radius = CORNER_RADIUS,
		height = 28,
		border_width = 0,
	},
})

-- Center pill (内蔵ディスプレイ専用)
sbar.add("bracket", "bracket.media.internal", {
	"/^center\\.media.*/",
	"center.notch",
	"weather",
	"date",
	"time",
}, {
	display = builtin_display, -- 【動的】
	background = {
		color = colors.bg3,
		corner_radius = 4,
		height = 24,
		border_width = 0,
	},
})

-- Center pill (外部モニター専用)
sbar.add("bracket", "bracket.media.external", {
	"/^center\\.media.*/",
	"center.external_gap",
	"weather",
	"date",
	"time",
}, {
	display = external_display, -- 【動的】
	background = {
		color = colors.bg3,
		corner_radius = 4,
		height = 24,
		border_width = 0,
	},
})

-- Right pill
sbar.add("bracket", "bracket.right", {
	"input",
	"brew",
	"widgets.cpu",
	"widgets.wifi",
	"widgets.bluetooth",
	"widgets.volume",
	"widgets.battery",
}, {
	display = "all",
	background = {
		color = colors.bg3,
		corner_radius = CORNER_RADIUS,
		height = 28,
		border_width = 0,
	},
})
--
--
--
--
-- local colors = require("colors")
--
-- require("items.apple")
-- -- require("items.menus")
-- require("items.spaces")
-- -- require("items.front_app")
-- require("items.media")
-- --
-- -- Adjust 'width' if items bleed under the notch:
-- --   14" MBP default res  → try 200–220
-- --   16" MBP default res  → try 220–250
-- sbar.add("item", "center.notch", {
-- 	position = "center",
-- 	width = 480,
-- 	icon = { drawing = false },
-- 	label = { drawing = false },
-- 	background = { color = colors.transparent },
-- })
-- --
-- require("items.weather")
-- require("items.calendar")
-- --
-- require("items.widgets.battery")
-- require("items.widgets.volume")
-- require("items.widgets.wifi")
-- require("items.widgets.cpu")
-- require("items.brew")
-- require("items.input")
-- --
-- -- require("items.widgets.input_source")
-- --
-- --
-- --
-- -- ══════════════════════════════════════════════════════════════
-- -- BRACKETS — drawn after all items are created
-- -- ══════════════════════════════════════════════════════════════
--
-- CORNER_RADIUS = 16
--
-- -- Left pill: Apple logo + Aerospace workspaces
-- sbar.add("bracket", "bracket.left", { "apple.logo", "/space\\..*/", "spaces.right_pad" }, {
-- 	background = {
-- 		color = colors.bg1,
-- 		corner_radius = CORNER_RADIUS,
-- 		height = 28,
-- 		border_width = 0,
-- 	},
-- })
--
-- sbar.add("bracket", "bracket.media", {
-- 	"/^center\\.media.*/",
-- 	"center.notch",
-- 	"weather",
-- 	"date",
-- 	"time",
-- }, {
-- 	background = {
-- 		color = colors.bg3,
-- 		corner_radius = 4,
-- 		height = 24,
-- 		border_width = 0,
-- 	},
-- })
-- --
-- -- -- Right pill: WiFi + Bluetooth + Volume + Battery
-- sbar.add("bracket", "bracket.right", {
-- 	"input",
-- 	"brew",
-- 	"widgets.cpu",
-- 	"widgets.wifi",
-- 	"widgets.bluetooth",
-- 	"widgets.volume",
-- 	"widgets.battery",
-- }, {
-- 	background = {
-- 		color = colors.bg3,
-- 		corner_radius = CORNER_RADIUS,
-- 		height = 28,
-- 		border_width = 0,
-- 	},
-- })
