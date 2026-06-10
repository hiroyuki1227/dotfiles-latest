-- require "items.widgets.messages"
require "items.widgets.volume"
require "items.widgets.wifi"
require "items.widgets.battery"
require "items.widgets.bluetooth"
require "items.widgets.messages"

sbar.add("bracket", { "/widgets\\..*/" }, {})

sbar.add("item", "widget.padding", {
  width = 16,
})
