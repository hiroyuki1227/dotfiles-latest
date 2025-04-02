require("config.option-add")
vim.g.mapleader = " "
local opt = vim.opt

vim.scriptencoding = "utf-8"
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

opt.spelllang = { "en", "cjk" }

opt.timeout = true
opt.timeoutlen = 1000
-- vim.g.snacks_animate = false
-- turn off swapfile
opt.swapfile = false
opt.relativenumber = true
opt.number = true
opt.title = true
opt.autoindent = true -- copy indent from current line when starting new one
opt.smartindent = true
opt.hlsearch = true -- highlight all matches on previous search pattern
opt.backup = false -- creates a backup file
opt.showcmd = true -- show command in last line of the screen
opt.cmdheight = 1 -- height of the command bar
opt.laststatus = 3 -- global statusline
opt.expandtab = true -- convert tabs to spaces
opt.scrolloff = 10 -- is one of my fav
opt.shell = "/opt/homebrew/bin/zsh"
opt.inccommand = "split"
opt.backupskip = "/tmp/*,/private/tmp/*"
opt.ignorecase = true -- ignore case when searching
opt.smarttab = true -- tab respects 'tabstop'
-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.breakindent = true -- set indent on newline
opt.backspace = "indent,eol,start" -- backspace through everything in insert mode
opt.path:append({ "**" }) -- finding files - search down into subfolders
opt.wildignore:append({ "*/node_modules/*" })

opt.mouse = "a" -- enable mouse support
opt.whichwrap:remove({ "b", "s", "h", "l" })
opt.wrap = false -- display lines as one long line(default: truet)
opt.signcolumn = "yes"

opt.linebreak = true -- Companion to wrap, don't split words (default: false)

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive
opt.cursorline = true -- highlight the current line

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard = "unnamedplus" -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom
opt.splitkeep = "cursor" -- split horizontal window to the bottom
--
-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })

vim.cmd([[au BufNewFile,BufRead *.astro setf astro]])
vim.cmd([[au BufNewFile,BufRead Podfile setf ruby]])

-- カーソル行の背景色を変更
vim.cmd([[
 highlight CursorLine guibg= #616a6b
 highlight CursorLineNr guibg= guibg=#323449 guifg= #f8c471
 highlight LineNrAbove guifg = #616A6B
 " highlight LineNr guifg = #F8C471
 highlight LineNrBelow guifg = #616A6B
 " highlight ColorColumn guibg =#323449
 highlight ColorColumn guibg =#616A6B
]])

-- カーソル行の強調表示を有効にする
opt.cursorline = true
-- "number" : 行番号だけ
-- "both" : 行全体
opt.cursorlineopt = "both" -- to enable cursorline!
opt.colorcolumn = "80"
-- opt.cursorcolumn = true
opt.ruler = true
opt.helplang = { "ja", "en" }
-- opt.whichwrap:append("b,s,h,l,<,>,[,],~")

-- set to `true` to follow the main branch
-- you need to have a working rust toolchain to build the plugin
-- in this case.
-- vim.g.lazyvim_blink_main = true

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
vim.g.lazyvim_prettier_needs_config = true
vim.g.lazyvim_picker = "telescope"
-- vim.g.lazyvim_picker = "fzf"
vim.g.lazyvim_cmp = "blink.cmp"
-- vim.g.lazyvim_python_lsp = "pyright"
-- vim.g.lazyvim_python_ruff = "ruff"
