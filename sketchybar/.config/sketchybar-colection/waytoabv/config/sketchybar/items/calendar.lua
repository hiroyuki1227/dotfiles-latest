local settings = require("settings")
local colors = require("colors")

-- Padding item required because of bracket
-- sbar.add("item", { position = "right", width = settings.group_paddings })

local cal = sbar.add("item", {
	icon = {
		color = colors.white,
		padding_left = 8,
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Semibold"],
			size = 14.0,
		},
	},
	label = {
		color = colors.white,
		-- color = colors.green,
		padding_right = 20,
		width = 60,
		align = "right",
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Semibold"],
			size = 14.0,
		},
	},
	position = "right",
	update_freq = 30,
	padding_left = 1,
	padding_right = 1,
	-- background = {
	-- 	color = colors.transparent,
	-- 	border_color = colors.gray,
	-- 	border_width = 3,
	-- },
	click_script = "open -a 'Calendar'",
})

-- Double border for calendar using a single item bracket
sbar.add("bracket", { cal.name }, {
	background = {
		color = colors.transparent,
		height = 30,
		-- border_color = colors.cyan,
		-- corner_radius = 32,
	},
})

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
	-- cal:set({ icon = os.date("%a /%d %b."), label = os.date("%H:%M") })
	cal:set({ icon = os.date("%b %d,20%y (%a) "), label = os.date(" %H:%M") })
end)
