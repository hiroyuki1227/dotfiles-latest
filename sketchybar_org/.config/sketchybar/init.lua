-- Require the sketchybar module
sbar = require("sketchybar")

-- Set the bar name, if you are using another bar instance than sketchybar
-- sbar.set_bar_name("bottom_bar")
sbar.add("evnet", "aerospace_workspace_change")
sbar.add("event", "aerospace_mode_change")

-- Bundle the entire initial configuration into a single message to sketchybar
sbar.begin_config()
require("bar")
require("default")
require("items")
sbar.end_config()

sbar.hotload(true)

sbar.event_loop()
