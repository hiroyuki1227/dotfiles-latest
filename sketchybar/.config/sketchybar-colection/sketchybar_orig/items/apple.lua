require "utils"
-- local colors = require "colors"
local colors = require "colors2"
local icons = require "icons"

sbar.add("item", "apple.logo", {
  position = "left",
  background = {
    image = {
      string = os.getenv "HOME" .. "/.config/sketchybar/assets/diamondRed.png",
      scale = 0.04,
    },
  },
  -- icon = {
  -- 	y_offset = 1,
  -- 	font = { size = 18.0 },
  -- 	color = colors.white,
  -- 	string = icons.apple,
  -- },
  label = { drawing = false },
  padding_left = 10,
  padding_right = 5,
  click_script = "/.config/sketchybar/helpers/menus/bin/menus -s 0",
})

sbar.add("item", {
  position = "left",
  width = 10,
  icon = {
    string = "|",
    font = { size = 16.0 },
    y_offset = 1,
    color = colors.with_alpha(colors.white, 0.3),
  },
})
-- require "utils"
--
-- local colors = require("colors").sections
-- local icons = require "icons"
--
-- sbar.add("item", {
--   icon = {
--     font = { size = 18 },
--     string = icons.apple,
--     padding_right = 8,
--     padding_left = 8,
--     color = colors.apple,
--   },
--   background = {
--     drawing = false,
--   },
--   label = { drawing = false },
--   click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",
-- })
--
-- apple:subscribe("mouse.clicked", function()
--   sbar.animate("tanh", 8, function()
--     apple:set {
--       background = {
--         shadow = {
--           distance = 0,
--         },
--       },
--       y_offset = -4,
--       padding_left = 8,
--       padding_right = 0,
--     }
--     apple:set {
--       background = {
--         shadow = {
--           distance = 4,
--         },
--       },
--       y_offset = 0,
--       padding_left = 4,
--       padding_right = 4,
--     }
--   end)
-- end)
