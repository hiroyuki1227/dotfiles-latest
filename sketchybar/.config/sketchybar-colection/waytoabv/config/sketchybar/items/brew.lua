-- Filename: ~/github/dotfiles-latest/sketchybar/felixkratz-linkarzu/items/brew.lua

local colors = require("colors")

-- brew_update イベントを登録（zshrc から brew update/upgrade 実行時にトリガー）
sbar.exec("sketchybar --add event brew_update")

local brew = sbar.add("item", "brew", {
	position = "right",
	icon = {
		string = "􀐛",
		color = colors.white,
	},
	label = {
		string = "?",
	},
	padding_right = 10,
	script = "$PLUGIN_DIR/brew.sh",
	updates = "when_shown",
})
-- Double border for calendar using a single item bracket
brew:subscribe({ "brew_update", "system_woke" })
