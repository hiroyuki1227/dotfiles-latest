LAYOUT_FULL = true
local colors = require("colors")

sbar.bar({
	topmost = "window",
	height = 40,
	-- color = colors.with_alpha(colors.green, 0.50),
	color = LAYOUT_FULL and colors.bar.bg or colors.transparent,
	border_color = LAYOUT_FULL and colors.bar.border or colors.transparent,
	border_width = 1,
	shadow = LAYOUT_FULL,
	position = "top",
	sticky = true,
	padding_right = 0,
	padding_left = 0,
	font_smoothing = true,
	y_offset = LAYOUT_FULL and 8 or 4,
	margin = 16,
	blur_radius = 4,
	corner_radius = LAYOUT_FULL and 8 or 0,
})
