local colors = require("colors")
require("items.apple")
-- require("items.menu")
require("items.spaces")
-- require("items.front_apps")

-- ──────────────── CENTER — LEFT of notch ──────────────────────
require("items.media")
-- ─────────────────────────── CENTER - RIGHT of notch ────────────────────────────
require("items.calendar")
require("items.widgets.weather")
-- ─────────────────────────── RIGHT ────────────────────────────
require("items.widgets.input")
require("items.widgets.battery")
require("items.widgets.bluetooth")
require("items.widgets.cpu")
require("items.widgets.wifi")
require("items.widgets.volume")
require("items.brew")
-- ══════════════════════════════════════════════════════════════
-- BRACKETS — drawn after all items are created
-- ══════════════════════════════════════════════════════════════

CORNER_RADIUS = 16

-- Left pill: Apple logo + Aerospace workspaces
sbar.add("bracket", "bracket.left", { "apple.logo", "/space\\..*/", "spaces.right_pad", "front_apps" }, {
	background = {
		color = colors.bg5,
		border_color = colors.bg1,
		corner_radius = CORNER_RADIUS,
		height = 28,
		border_width = 1,
	},
})

-- The pill background spans both halves; the notch hardware creates the visual gap.

sbar.set("bracket", "bracket.media", "/^center.media.*/", {
	position = "e",
	-- "/^widgets\\.weather.*/",
	-- "center.time",
	-- "center.date",
}, {
	background = {
		color = colors.bg5,
		corner_radius = CORNER_RADIUS,
		height = 28,
		border_width = 1,
	},
})

-- Right pill: WiFi + Bluetooth + Volume + Battery
sbar.add("bracket", "bracket.right", {
	-- "input_source",
	"/^widgets\\.weather.*/",
	"center.time",
	"center.date",
	"widgets.cpu",
	"widgets.wifi",
	"widgets.bluetooth",
	"widgets.volume",
	"widgets.battery",
	"widgets.input",
	"brew",
}, {
	background = {
		color = colors.bg5,
		border_color = colors.bg1,
		corner_radius = CORNER_RADIUS,
		height = 28,
		border_width = 1,
	},
})
