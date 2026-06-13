local colors = require("colors")

require("items.apple")
-- require("items.menus")
require("items.spaces")
-- require("items.front_app")
require("items.media")
--
-- Adjust 'width' if items bleed under the notch:
--   14" MBP default res  → try 200–220
--   16" MBP default res  → try 220–250
sbar.add("item", "center.notch", {
	position = "center",
	width = 200,
	icon = { drawing = false },
	label = { drawing = false },
	background = { color = colors.transparent },
})
--
require("items.weather")
require("items.calendar")
--
require("items.widgets.battery")
require("items.widgets.volume")
require("items.widgets.wifi")
require("items.widgets.cpu")
require("items.brew")
require("items.input")
--
-- require("items.widgets.input_source")
--
--
--
-- ══════════════════════════════════════════════════════════════
-- BRACKETS — drawn after all items are created
-- ══════════════════════════════════════════════════════════════

CORNER_RADIUS = 16

-- Left pill: Apple logo + Aerospace workspaces
sbar.add("bracket", "bracket.left", { "apple.logo", "/space\\..*/", "spaces.right_pad" }, {
	background = {
		color = colors.bg1,
		corner_radius = CORNER_RADIUS,
		height = 28,
		border_width = 0,
	},
})

sbar.add("bracket", "bracket.media", {
	"/^center\\.media.*/",
	"center.notch",
	"weather",
	"date",
	"time",
}, {
	background = {
		color = colors.bg3,
		corner_radius = 4,
		height = 24,
		border_width = 0,
	},
})
--
-- -- Right pill: WiFi + Bluetooth + Volume + Battery
sbar.add("bracket", "bracket.right", {
	"input",
	"brew",
	"widgets.cpu",
	"widgets.wifi",
	"widgets.bluetooth",
	"widgets.volume",
	"widgets.battery",
}, {
	background = {
		color = colors.bg3,
		corner_radius = CORNER_RADIUS,
		height = 28,
		border_width = 0,
	},
})
