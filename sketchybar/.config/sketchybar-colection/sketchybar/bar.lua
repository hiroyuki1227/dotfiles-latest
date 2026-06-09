local colors = require "colors"
LAYOUT_FULL = true

-- Equivalent to the --bar domain
sbar.bar {
  topmost = "window",
  height = 40,
  color = LAYOUT_FULL and 0xff000000 or colors.transparent,
  -- color = colors.bg,
  y_offset = LAYOUT_FULL and 8 or 6,
  sticky = true,
  shadow = LAYOUT_FULL,
  position = "top",
  padding_right = 0,
  padding_left = 0,
  -- border_color = colors.border,
  border_width = 0,
  blur_radius = 0,
  margin = 32,
  corner_radius = LAYOUT_FULL and 24 or 0,
}
