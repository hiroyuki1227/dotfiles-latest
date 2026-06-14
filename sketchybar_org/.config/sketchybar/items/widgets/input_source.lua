sbar.exec(
	"defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources"
		.. " | plutil -convert xml1 -o - -"
		.. " | grep -A1 'KeyboardLayout Name' | tail -n1"
		.. " | cut -d '>' -f2 | cut -d '<' -f1",
	function(current_input)
		-- local icon = (current_input:gsub("%s+", "") == "ABC") and "􀂕" or "􀂩"
		local icon = (current_input:gsub("%s+", "") == "ABC") and "🇺🇸" or "🇯🇵"
		sbar.set("input_source", { icon = { string = icon } })
	end
)
