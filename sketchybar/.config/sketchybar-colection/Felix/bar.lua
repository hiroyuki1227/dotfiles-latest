local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
	height = 40,
	border_color = colors.bar.border,
	color = colors.bar.bg,
	shadow = true,
	sticky = true,
	padding_right = 2,
	padding_left = 2,
	blur_radius = 2,
	topmost = "window",
})
