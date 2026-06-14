LAYOUT_FULL = true
local colors = require("colors")

sbar.bar({
	topmost = "window",
	height = 40,
	color = LAYOUT_FULL and colors.bg1 or colors.transparent,
	border_width = 0,
	shadow = LAYOUT_FULL,
	position = "top",
	sticky = true,
	padding_right = 0,
	padding_left = 0,
	y_offset = LAYOUT_FULL and 8 or 6,
	margin = 8,
	blur_radius = 0,
	corner_radius = LAYOUT_FULL and 8 or 0,
})
