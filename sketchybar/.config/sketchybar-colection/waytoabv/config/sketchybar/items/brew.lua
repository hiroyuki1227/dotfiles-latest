-- brew_item.lua
-- brew アイテムの登録スクリプト (SbarLua版)
-- 対応シェルスクリプト: brewbar.sh (アイテム追加・設定・イベント購読)

local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- カスタムイベントを登録
-- 対応: sketchybar --add event brew_update
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
sbar.add("event", "brew_update")
sbar.add("item", { position = "right", width = settings.group_paddings })

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- メインアイテムを追加・設定
-- 対応: --add item brew right / --set brew ...
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local brew = sbar.add("item", "brew", {
	position = "right",
	script = "$PLUGIN_DIR/brew.lua",
	click_script = "sketchybar --set brew popup.drawing=toggle",
	icon = {
		string = "􀐛",
		color = colors.green,
	},
	update_freq = 30,
	padding_right = 15,
	popup = {
		align = "right",
		height = 20,
	},
	background = {
		color = colors.transparent,
		-- border_color = colors.cyan,
		height = 30,
		-- corner_radius = 32,
	},
})

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- イベント購読 (各イベントに個別コールバックを渡す)
-- subscribe() は必ずコールバック関数が必要なため個別に記述
-- 対応: --subscribe brew brew_update mouse.entered ...
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- brew_update / routine / forced → プラグインスクリプトに委譲
brew:subscribe("brew_update", function(_) end)

-- マウスイベント → ポップアップ開閉
brew:subscribe("mouse.entered", function(_)
	brew:set({ popup = { drawing = true } })
end)

brew:subscribe("mouse.exited", function(_)
	brew:set({ popup = { drawing = false } })
end)

brew:subscribe("mouse.exited.global", function(_)
	brew:set({ popup = { drawing = false } })
end)

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- ポップアップヘッダーアイテムを追加・設定
-- 対応: --add item brew.details popup.brew / --set brew.details ...
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local brew_details = sbar.add("item", "brew.details", {
	position = "popup." .. brew.name,
	background = {
		padding_left = 5,
		padding_right = 5,
		color = colors.bg1,
		border_width = 1,
	},
	click_script = "sketchybar --set brew popup.drawing=off",
})

-- -- Filename: ~/github/dotfiles-latest/sketchybar/felixkratz-linkarzu/items/brew.lua
--
-- local colors = require("colors")
--
-- PLUGINS_DIR = os.getenv("HOME") .. "/.config/sketchybar/widgets"
-- -- brew_update イベントを登録（zshrc から brew update/upgrade 実行時にトリガー）
-- sbar.exec("sketchybar --add event brew_update")
--
-- local brew = sbar.add("item", "brew", {
-- 	position = "right",
-- 	icon = {
-- 		string = "􀐛",
-- 		color = colors.white,
-- 	},
-- 	label = {
-- 		string = "?",
-- 	},
-- 	padding_right = 10,
-- 	script = "$PLUGIN_DIR/brew.sh",
-- 	updates = "when_shown",
-- })
-- -- Double border for calendar using a single item bracket
-- brew:subscribe({ "brew_update", "system_woke" })
