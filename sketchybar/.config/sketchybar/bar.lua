LAYOUT_FULL = true
local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
	position = "top",
	topmost = "window",
	height = 48,
	-- color = colors.white,
	-- color = colors.transparent,
	color = LAYOUT_FULL and colors.bg1 or colors.transparent,
	padding_right = 0,
	padding_left = 0,
	margin = 10,
	y_offset = LAYOUT_FULL and 2 or 2,
	blur_radius = 0,
	font_smoothing = true,
	border_width = 0,
	shadow = LAYOUT_FULL,
	sticky = true,
	corner_radius = LAYOUT_FULL and 32 or 0,
})
