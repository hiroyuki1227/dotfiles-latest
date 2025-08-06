if vim.loader then
  vim.loader.enable()
end

_G.dd = function(...)
  require("util.debug").dump(...)
end
vim.print = _G.dd

vim.g.md_heading_bg = "transparent"
require("config.lazy")
require("config.highlights")
