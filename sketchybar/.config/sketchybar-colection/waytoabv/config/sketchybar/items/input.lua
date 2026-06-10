local colors = require("colors")
local settings = require("settings")

local input_source = sbar.add("item", "input_source", {
	position = "right",
	icon = {
		string = "􀂕",
		font = {
			family = settings.font.text,
			style = "Regular",
			size = 20.0,
		},
		color = colors.white,
	},
	label = { drawing = false },
	script = "$PLUGIN_DIR/input_source.lua",
	update_freq = 1,
})

input_source:subscribe("routine", function(env)
	sbar.exec(
		"defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources"
			.. " | plutil -convert xml1 -o - -"
			.. " | grep -A1 'KeyboardLayout Name' | tail -n1"
			.. " | cut -d '>' -f2 | cut -d '<' -f1",
		function(current_input)
			-- local icon = (current_input:gsub("%s+", "") == "ABC") and "􀂕" or "􀜟"
			-- local icon = (current_input:gsub("%s+", "") == "ABC") and "ABC" or "あ"
			local icon = (current_input:gsub("%s+", "") == "ABC") and "􀂕" or "🅙"
			sbar.set("input_source", { icon = { string = icon } })
		end
	)
end)
