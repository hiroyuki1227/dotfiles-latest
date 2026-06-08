---@type Colors
local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
	topmost = "window",
	height = 40,
	---@type number
	-- color = colors.transparent,
	color = colors.bar.bg,
	y_offset = 4,
	margin = 6,
	corner_radius = 24,
	padding_right = 2,
	padding_left = 2,
	blur_radius = 64,
	font_smoothing = true,
})
