-- Specify leader the default in lazyvim is " "
vim.g.mapleader = " "
-- relaxed default of 1000ms here.
vim.opt.timeout = true
-- Default neovim is 1,000 but lazyvim sets it to 300
vim.opt.timeoutlen = 1000

-- I find the animations a bit laggy
vim.g.snacks_animate = false

-- Conditional settings based on mode
-- disable winbar entirely
vim.opt.winbar = ""

-- Disable the gutter
vim.opt.signcolumn = "no"

-- Disables the statusbar at the bottom
vim.opt.laststatus = 0

-- No colorcolumn in skitty
vim.opt.colorcolumn = ""
-- I never used relative line numbers, so fuck that
-- Edit a few days after, I'll give them a try again, so re-enabled them
-- Fuck relative numbers, I'm done with them
vim.opt.relativenumber = true

-- When text reaches this limit, it automatically wraps to the next line.
-- This WILL NOT auto wrap existing lines, or if you paste a long line into a
-- file it will not wrap it as well
-- https://www.reddit.com/r/neovim/comments/1av26kw/i_tried_to_figure_it_out_but_i_give_up_how_do_i/
vim.opt.textwidth = 80

-- Above option applies the setting to ALL file types, if you want to apply it
-- to specific files only
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "markdown",
--   -- pattern = {"python", "javascript", "html"},
--   callback = function()
--     vim.opt_local.textwidth = 80
--   end,
-- })

-- -- Disable line wrap, set to false by default in lazyvim
vim.opt.wrap = true

-- Shows colorcolumn that helps me with markdown guidelines.
-- This is the vertical bar that shows the 80 character limit
-- This applies to ALL file types
vim.opt.colorcolumn = "80"

-- -- To apply it to markdown files only
-- vim.api.nvim_create_autocmd("BufWinEnter", {
--   pattern = { "*.md" },
--   callback = function()
--     vim.opt.colorcolumn = "80"
--     vim.opt.textwidth = 80
--   end,
-- })

-- Winbar
-- Function to shorten long paths (> shorten_if_more_than real dirs)
local function shorten_path(path)
  local shorten_if_more_than = 6 -- change this to 5, 7, etc
  -- Strip and remember the root ("/" or "~/")
  local prefix = ""
  if path:sub(1, 2) == "~/" then
    prefix = "~/"
    path = path:sub(3)
  elseif path:sub(1, 1) == "/" then
    prefix = "/"
    path = path:sub(2)
  end
  -- Split the remaining path into its components
  local parts = {}
  for part in string.gmatch(path, "[^/]+") do
    table.insert(parts, part)
  end
  -- Shorten only when there are more than shorten_if_more_than directories
  if #parts > shorten_if_more_than then
    local last_six = table.concat({
      parts[#parts - 5],
      parts[#parts - 4],
      parts[#parts - 3],
      parts[#parts - 2],
      parts[#parts - 1],
      parts[#parts],
    }, "/")
    return "../" .. last_six
  end

  -- Re-attach the prefix when no shortening is needed
  return prefix .. table.concat(parts, "/")
end
-- Function to get the full path and replace the home directory with ~
local function get_winbar_path()
  local full_path = vim.fn.expand("%:p:h")
  return full_path:gsub(vim.fn.expand("$HOME"), "~")
end
-- Function to get the number of open buffers using the :ls command
local function get_buffer_count()
  return vim.fn.len(vim.fn.getbufinfo({ buflisted = 1 }))
end
-- Function to update the winbar
local function update_winbar()
  local home_replaced = get_winbar_path()
  local buffer_count = get_buffer_count()
  local display_path = shorten_path(home_replaced)
  vim.opt.winbar = "%#WinBar1#%m "
    .. "%#WinBar2#("
    .. buffer_count
    .. ") "
    -- this shows the filename on the left
    .. "%#WinBar3#"
    .. vim.fn.expand("%:t")
    -- This shows the file path on the right
    .. "%*%=%#WinBar1#"
    .. display_path
  -- I don't need the hostname as I have it in lualine
  -- .. vim.fn.systemlist("hostname")[1]
end
-- Winbar was not being updated after I left lazygit
vim.api.nvim_create_autocmd({ "BufEnter", "ModeChanged" }, {
  callback = function(args)
    local old_mode = args.event == "ModeChanged" and vim.v.event.old_mode or ""
    local new_mode = args.event == "ModeChanged" and vim.v.event.new_mode or ""
    -- Only update if ModeChanged is relevant (e.g., leaving LazyGit)
    if args.event == "ModeChanged" then
      -- Get buffer filetype
      local buf_ft = vim.bo.filetype
      -- Only update when leaving `snacks_terminal` (LazyGit)
      if buf_ft == "snacks_terminal" or old_mode:match("^t") or new_mode:match("^n") then
        update_winbar()
      end
    else
      update_winbar()
    end
  end,
})

vim.opt.conceallevel = 0

-- https://github.com/folke/lazy.nvim/issues/702#issuecomment-1903484213
-- vim.notify("auto updating plugins", vim.log.levels.INFO)
local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup("autoupdate"),
  callback = function()
    if require("lazy.status").has_updates then
      require("lazy").update({ show = false })
    end
  end,
})

-- I added `localoptions` to save the language spell settings, otherwise, the
-- language of my markdown documents was not remembered if I set it to spanish
-- or to both en,es
-- See the help for `sessionoptions`
-- `localoptions`: options and mappings local to a window or buffer
-- (not global values for local options)
--
-- The plugin that saves the session information is
-- https://github.com/folke/persistence.nvim and comes enabled in the
-- lazyvim.org distro lamw25wmal
--
-- These sessionoptions come from the lazyvim distro, I just added localoptions
-- https://www.lazyvim.org/configuration/general
vim.opt.sessionoptions = {
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds",
  "localoptions",
}

vim.opt.spelllang = { "en" }

vim.o.updatetime = 200
