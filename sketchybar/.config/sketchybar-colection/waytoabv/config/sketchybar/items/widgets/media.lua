local media = require("items.media")
local app_icons = require("helpers.app_icons")

media:subscribe("media_change", function(env)
	local info = env.INFO

	if info.state ~= "playing" then
		media:set({
			drawing = false,
		})

		return
	end

	media:set({
		drawing = true,

		icon = {
			string = app_icons[info.app] or "󰎈",
		},

		label = string.format("%s - %s", info.title or "", info.artist or ""),
	})
end)
