#!/usr/bin/env lua
-- This is only needed once to install the sketchybar module
-- (or for an update of the module)
os.execute(
	"[ ! -d $HOME/.local/share/sketchybar_lua/ ] && (git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)"
)

-- Add the sketchybar module to the package cpath (the module could be
-- installed into the default search path then this would not be needed)
package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"
-- Require the sketchybar module
sbar = require("sketchybar")

-- Set the bar name, if you are using another bar instance than sketchybar
-- sbar.set_bar_name("bottom_bar")

-- Bundle the entire initial configuration into a single message to sketchybar
sbar.begin_config()
require("bar")
require("default")
require("items")
sbar.end_config()
--
-- Run the event loop of the sketchybar module (without this there will be no
-- callback functions executed in the lua module)
sbar.event_loop()
