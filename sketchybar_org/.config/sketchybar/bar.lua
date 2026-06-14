LAYOUT_FULL = true
local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
	topmost = "window",
	height = 40,
	-- color = colors.white,
	-- color = colors.transparent,
	color = LAYOUT_FULL and colors.bg1 or colors.transparent,
	border_width = 0,
	shadow = LAYOUT_FULL,
	position = "top",
	sticky = true,
	padding_right = 2,
	padding_left = 2,
	y_offset = LAYOUT_FULL and 8 or 6,
	margin = 6,
	font_smoothing = true,
	blur_radius = 0,
	corner_radius = LAYOUT_FULL and 9 or 0,
})
