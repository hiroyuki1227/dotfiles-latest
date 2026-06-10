local colors = require "colors2"

--left
require "items.apple"
-- require "items.spaces"
-- require "items.menus"

-- ---------------------CENTER - LEFT of notch
-- require "items.media"

-- Invisible spacer that covers the MacBook Pro notch.
-- Adjust 'width' if items bleed under the notch:
--   14" MBP default res  → try 200–220
--   16" MBP default res  → try 220–250
-- sbar.add("item", "center.notch", {
--   position = "center",
--   width = 200,
--   icon = { drawing = false },
--   label = { drawing = false },
--   background = { color = colors.transparent },
-- })

-- ──────────────── CENTER — RIGHT of notch ─────────────────────

-- require "items.weather"
-- require "items.calendar"

-- ─────────────────────────── RIGHT ────────────────────────────
-- require "items.widgets"

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

-- Center notch pill: media — [notch] — time + date
-- The pill background spans both halves; the notch hardware creates the visual gap.
sbar.add("bracket", "bracket.media", {
  "/^center\\.media.*/",
  "center.notch",
  "center.weather",
  "center.time",
  "center.date",
}, {
  background = {
    color = colors.bg3,
    corner_radius = 4,
    height = 24,
    border_width = 0,
  },
})

-- Right pill: WiFi + Bluetooth + Volume + Battery
sbar.add("bracket", "bracket.right", {
  "widgets.wifi",
  "widgets.bluetooth",
  "widgets.volume",
  "widgets.battery",
}, {
  background = {
    color = colors.bg1,
    corner_radius = CORNER_RADIUS,
    height = 28,
    border_width = 0,
  },
})
-- -- require "items.calendar"
-- -- require "items.widgets"
-- -- require "items.spotify"
