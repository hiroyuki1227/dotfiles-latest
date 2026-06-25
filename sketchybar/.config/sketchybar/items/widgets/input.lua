local colors = require("colors")
local settings = require("settings")

local input_source = sbar.add("item", "input_source", {
	position = "right",
	icon = {
		string = "🇺🇸", -- 初期値
		font = {
			family = settings.font.text_round,
			style = settings.font.style_map["Regular"],
			size = 14.0,
		},
		color = colors.white,
	},
	label = { drawing = false },
	background = {
		color = colors.transparent,
		height = 30,
		border_color = colors.cyan,
		corner_radius = 32,
	},
	update_freq = 1,
})

-- 共通のアイコン更新関数
local function update_input_icon()
	sbar.exec(
		"defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources"
			.. " | plutil -convert xml1 -o - -"
			.. " | grep -A1 'KeyboardLayout Name' | tail -n1"
			.. " | cut -d '>' -f2 | cut -d '<' -f1",
		function(current_input)
			local icon = (current_input:gsub("%s+", "") == "ABC") and "🇺🇸" or "🇯🇵"
			-- local icon = (current_input:gsub("%s+", "") == "ABC") and "󰌌:🇺🇸" or "󰌌:🇯🇵"
			sbar.set("input_source", { icon = { string = icon } })
		end
	)
end

-- 定期更新（update_freq = 1 に対応）
input_source:subscribe("routine", function(env)
	update_input_icon()
end)

-- 起動時に即時実行
update_input_icon()

-- local colors = require("colors")
-- local settings = require("settings")
--
-- PLUGINS_DIR = os.getenv("HOME") .. "/.config/sketchybar/widgets"
--
-- -- sbar.add("item", { position = "right", width = settings.group_paddings })
-- local input_source = sbar.add("item", "input_source", {
-- 	position = "right",
-- 	icon = {
-- 		string = "􀂕",
-- 		font = {
-- 			family = settings.font.text,
-- 			style = settings.font.style_map["Regular"],
-- 			size = 20.0,
-- 		},
-- 		color = colors.white,
-- 	},
-- 	label = { drawing = false },
-- 	script = "$PLUGIN_DIR/input_source.lua",
-- 	background = {
-- 		color = colors.transparent,
-- 		height = 30,
-- 		border_color = colors.cyan,
-- 		corner_radius = 32,
-- 	},
-- 	update_freq = 1,
-- })
--
-- input_source:subscribe("routine", function(env)
-- 	sbar.exec(
-- 		"defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources"
-- 			.. " | plutil -convert xml1 -o - -"
-- 			.. " | grep -A1 'KeyboardLayout Name' | tail -n1"
-- 			.. " | cut -d '>' -f2 | cut -d '<' -f1",
-- 		function(current_input)
-- 			-- local icon = (current_input:gsub("%s+", "") == "ABC") and "􀂕" or "􀜟"
-- 			-- local icon = (current_input:gsub("%s+", "") == "ABC") and "ABC" or "あ"
-- 			local icon = (current_input:gsub("%s+", "") == "ABC") and "🇺🇸" or "🇯🇵"
-- 			-- sbar.set("input_source", { icon = { string = icon } })
-- 			-- local icon = (current_input:gsub("%s+", "") == "ABC") and "􀂕" or "🅙"
-- 			sbar.set("input_source", { icon = { string = icon } })
-- 		end
-- 	)
-- end)
