-- Filename: ~/github/dotfiles-latest/sketchybar/felixkratz-linkarzu/plugins/brew.lua

local colors = require("colors")

-- brew outdated のカウントを取得
sbar.exec("brew outdated | wc -l | tr -d ' '", function(count_str)
	local count = tonumber(count_str) or 0

	local color = colors.red
	local label = tostring(count)

	if count == 0 then
		color = colors.green
		label = "􀆅"
	elseif count <= 9 then
		color = colors.white
	elseif count <= 29 then
		color = colors.yellow
	elseif count <= 59 then
		color = colors.orange
	end
	-- 60以上は red のまま

	sbar.set("brew", {
		label = { string = label },
		icon = { color = color },
	})
end)
