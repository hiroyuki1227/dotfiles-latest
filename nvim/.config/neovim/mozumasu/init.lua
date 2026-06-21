-- :lua print(vim.env.NEOVIM_MODE)
-- Here we capture the environment variable to make it accessible to neovim
--
-- NOTE: To see all the files modified for skitty-notes just search for "neovim_mode"
vim.g.neovim_mode = vim.env.NEOVIM_MODE or "default"
vim.g.scrollback_mode = vim.env.SCROLLBACK_MODE or "default"
vim.g.simpler_scrollback = vim.env.SIMPLER_SCROLLBACK or "default"
-- vim.g.bullets_enable_in_empty_buffers = 0

-- -- I have 2 style options "solid" and "transparent"
-- -- This style is defined in my zshrc file
-- -- :lua print(vim.env.MD_HEADING_BG)
vim.g.md_heading_bg = vim.env.MD_HEADING_BG

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Load custom highlights, I tried adding this as an autocommand, in the options.lua
-- file, also in the markdownl.lua file, but the highlights kept being overriden
-- so this is the only way I was able to make it work
-- Require the colors.lua module and access the colors directly without
-- additional file reads
require("config.highlights")

-- python
vim.g.python3_host_prog = "/opt/homebrew/bin/python3"
vim.g.python_host_prog = "/opt/homebrew/bin/python3"
