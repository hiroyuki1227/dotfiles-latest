require("utils")
local colors = require("colors")
local icons = require("icons")

sbar.add("item", "apple.logo", {
	position = "left",
	-- background = {
	-- 	image = {
	-- 		string = os.getenv("HOME") .. "/.config/sketchybar/assets/diamondRed.png",
	-- 		scale = 0.04,
	-- 	},
	-- },
	icon = {
		y_offset = 1,
		font = { size = 18.0 },
		color = colors.white,
		string = icons.apple,
	},
	label = { drawing = false },
	padding_left = 10,
	padding_right = 5,
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",
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
-- sbar.add("item", "apple.logo", {
-- 	position = "left",
-- --
-- -- Padding item required bec
-- sbar.add("item", { width = 5 })
--
-- local apple = sbar.add("item", {
-- 	icon = {
-- 		font = { size = 16.0 },
-- 		string = icons.apple,
-- 		padding_right = 8,
-- 		padding_left = 8,
-- 	},
-- 	label = { drawing = false },
-- 	background = {
-- 		color = colors.bg2,
-- 		border_color = colors.black,
-- 		border_width = 1,
-- 	},
-- 	padding_left = 1,
-- 	padding_right = 1,
-- 	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",
-- })
--
-- -- Double border for apple using a single item bracket
-- sbar.add("bracket", { apple.name }, {
-- 	background = {
-- 		color = colors.transparent,
-- 		height = 30,
-- 		border_color = colors.grey,
-- 	},
-- })
--
--
-- -- Padding item required because of bracket
-- sbar.add("item", { width = 7 })
