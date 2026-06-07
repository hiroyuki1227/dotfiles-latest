local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
	height = 40,
	-- color = colors.bar.bg,
	color = colors.transparent,
	border_color = colors.bar.border,
	padding_right = 2,
	padding_left = 2,
	blur_radius = 64,
	corner_radius = 16,
	font_smoothing = true,
})
