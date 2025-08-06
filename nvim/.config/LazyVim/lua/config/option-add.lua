vim.g.mapleader = " "
vim.opt.timeout = true
vim.opt.timeoutlen = 1000
vim.g.snacks_animate = false
vim.opt.relativenumber = false
vim.opt.textwidth = 80
vim.opt.wrap = true
vim.opt.colorcolumn = "80"
local colors = require("config.colors")
vim.cmd(string.format([[highlight WinBar1 guifg=%s]], colors["linkarzu_color03"]))
vim.cmd(string.format([[highlight WinBar2 guifg=%s]], colors["linkarzu_color02"]))
vim.cmd(string.format([[highlight WinBar3 guifg=%s gui=bold]], colors["linkarzu_color24"]))
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
  vim.opt.winbar = "%#WinBar1#%m "
    .. "%#WinBar2#("
    .. buffer_count
    .. ") "
    -- this shows the filename on the left
    .. "%#WinBar3#"
    .. vim.fn.expand("%:t")
    -- This shows the file path on the right
    .. "%*%=%#WinBar1#"
    .. home_replaced
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

-- ############################################################################
--                             Neovide section
-- ############################################################################

-- NOTE: When in LazyGit if inside or outside neovim, if you want to edit files with
-- Neovide, you have to set the os.edit option in the
-- ~/github/dotfiles-latest/lazygit/config.yml file

-- NOTE: Also remember that there are settings in the file:
-- ~/github/dotfiles-latest/neovide/config.toml

-- NOTE: Text looks a bit bolder in Neovide, it doesn't bother me, but I think
-- there's no way to fix it, see:
-- https://github.com/neovide/neovide/issues/1231

-- The copy and paste sections were found on:
-- https://neovide.dev/faq.html#how-can-i-use-cmd-ccmd-v-to-copy-and-paste
if vim.g.neovide then
  vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
  vim.keymap.set("v", "<D-c>", '"+y') -- Copy
  vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
  vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
  vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode

  -- This allows me to use cmd+v to paste stuff into neovide
  vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })

  -- Specify the font used by Neovide
  -- vim.o.guifont = "MesloLGM_Nerd_Font:h14"
  vim.o.guifont = "CodeNewRoman Nerd Font Mono:h15"
  -- vim.o.guifont = "JetBrainsMono Nerd Font:h15"
  -- This is limited by the refresh rate of your physical hardware, but can be
  -- lowered to increase battery life
  -- This setting is only effective when not using vsync,
  -- for example by passing --no-vsync on the commandline.
  --
  -- NOTE: vsync is configured in the neovide/config.toml file, I disabled it and set
  -- this to 120 even though my monitor is 75Hz, had a similar case in wezterm,
  -- see: https://github.com/wez/wezterm/issues/6334
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_refresh_rate_idle = 5
  -- This is how fast the cursor animation "moves", default 0.06
  vim.g.neovide_cursor_animation_length = 0.04
  -- Default 0.7
  vim.g.neovide_cursor_trail_size = 0.7
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_cursor_animate_in_insert_mode = true
  vim.g.neovide_cursor_animate_command_line = true
  vim.g.neovide_cursor_unfocused_outline_width = 0.125
  vim.g.neovide_cursor_smooth_blink = true
  vim.g.neovide_cursor_vfx_mode = "railgun"
  -- vim.g.neovide_cursor_vfx_mode = "torpedo"
  -- vim.g.neovide_cursor_vfx_mode = "pixiedust"
  -- vim.g.neovide_cursor_vfx_mode = "sonicboom"
  -- vim.g.neovide_cursor_vfx_mode = "ripple"
  -- vim.g.neovide_cursor_vfx_mode = "wireframe"
  vim.g.neovide_cursor_vfx_opacity = 200.0
  vim.g.neovide_cursor_vfx_particle_lifetime = 1.2
  vim.g.neovide_cursor_vfx_particle_density = 9.0
  vim.g.neovide_cursor_vfx_particle_speed = 10.0
  vim.g.neovide_cursor_vfx_particle_phase = 1.5
  vim.g.neovide_cursor_vfx_particle_curl = 1.0
  -- produce particles behind the cursor, if want to disable them, set it to ""

  -- Really weird issue in which my winbar would be drawn multiple times as I
  -- scrolled down the file, this fixed it, found in:
  -- https://github.com/neovide/neovide/issues/1550
  vim.g.neovide_scroll_animation_length = 0.3
  vim.g.neovide_scroll_animation_for_lines = 5

  -- This allows me to use the right "alt" key in macOS, because I have some
  -- neovim keymaps that use alt, like alt+t for the terminal
  -- https://youtu.be/33gQ9p-Zp0I
  vim.g.neovide_input_macos_option_key_is_meta = "only_right"

  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
  vim.g.neovide_floating_corner_radius = 0.3
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 10

  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_redius = 5

  vim.g.neovide_show_border = true
  -- プロファイラを有効にする
  vim.g.neovide_profiler = false
  -- ウィンドウサイズを記憶
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_theme = "auto"

  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0

  vim.g.neovide_remember_window_size = true
  local function set_ime(args)
    if args.event:match("Enter$") then
      vim.g.neovide_input_ime = true
    else
      vim.g.neovide_input_ime = false
    end
  end

  local ime_input = vim.api.nvim_create_augroup("ime_input", { clear = true })

  vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
    group = ime_input,
    pattern = "*",
    callback = set_ime,
  })

  vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
    group = ime_input,
    pattern = "[/\\?]",
    callback = set_ime,
  })
  -- vim.g.neovide_input_ime = true
  ---- IMEの設定
  -- local function set_ime(args)
  --   if args.event:match("Enter$") then
  --     vim.g.neovide_input_ime = true
  --   else
  --     vim.g.neovide_input_ime = false
  --   end
  -- end
  --
  -- local ime_input = vim.api.nvim_create_augroup("ime_input", { clear = true })
  --
  -- vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
  --   group = ime_input,
  --   pattern = "*",
  --   callback = set_ime,
  -- })
  --
  -- vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
  --   group = ime_input,
  --   pattern = "[/\\?]",
  --   callback = set_ime,
  -- })

  --
  -- vim.g.neovide_background_color = "#24283b"
  vim.g.neovide_window_blurred = true
  vim.g.neovide_opacity = 0.6
  vim.g.neovide_normal_opacity = 0.6
  vim.g.transparency = 0.6
  --
  vim.g.neovide_text_gamma = 0.0
  vim.g.neovide_text_contrast = 0.5

  -- tokyonight
  vim.g.terminal_color_0 = "#1d202f"
  vim.g.terminal_color_1 = "#f7768e"
  vim.g.terminal_color_2 = "#9ece6a"
  vim.g.terminal_color_3 = "#e0af68"
  vim.g.terminal_color_4 = "#7aa2f7"
  vim.g.terminal_color_5 = "#bb9af7"
  vim.g.terminal_color_6 = "#7dcfff"
  vim.g.terminal_color_7 = "#a9b1d6"
  vim.g.terminal_color_8 = "#414868"
  vim.g.terminal_color_9 = "#ff899d"
  vim.g.terminal_color_10 = "#9fe044"
  vim.g.terminal_color_11 = "#faba4a"
  vim.g.terminal_color_12 = "#8db0ff"
  vim.g.terminal_color_13 = "#c7a9ff"
  vim.g.terminal_color_14 = "#a4daff"
  vim.g.terminal_color_15 = "#c0caf5"
  --
  --   catppuccin-moch
  -- vim.g.terminal_color_0 = "#45475a"
  -- vim.g.terminal_color_1 = "#f38ba8"
  -- vim.g.terminal_color_2 = "#a6e3a1"
  -- vim.g.terminal_color_3 = "#f9e2af"
  -- vim.g.terminal_color_4 = "#89b4fa"
  -- vim.g.terminal_color_5 = "#f5c2e7"
  -- vim.g.terminal_color_6 = "#94e2d5"
  -- vim.g.terminal_color_7 = "#bac2de"
  -- vim.g.terminal_color_8 = "#585b70"
  -- vim.g.terminal_color_9 = "#f38ba8"
  -- vim.g.terminal_color_10 = "#a6e3a1"
  -- vim.g.terminal_color_11 = "#f9e2af"
  -- vim.g.terminal_color_12 = "#89b4fa"
  -- vim.g.terminal_color_13 = "#f5c2e7"
  -- vim.g.terminal_color_14 = "#94e2d5"
  -- vim.g.terminal_color_15 = "#a6adc8"

  -- tokyonight_night
  -- vim.g.terminal_color_0 = "#15161e"
  -- vim.g.terminal_color_1 = "#f7768e"
  -- vim.g.terminal_color_2 = "#9ece6a"
  -- vim.g.terminal_color_3 = "#e0af68"
  -- vim.g.terminal_color_4 = "#7aa2f7"
  -- vim.g.terminal_color_5 = "#bb9af7"
  -- vim.g.terminal_color_6 = "#7dcfff"
  -- vim.g.terminal_color_7 = "#a9b1d6"
  -- vim.g.terminal_color_8 = "#414868"
  -- vim.g.terminal_color_9 = "#f7768e"
  -- vim.g.terminal_color_10 = "#9ece6a"
  -- vim.g.terminal_color_11 = "#e0af68"
  -- vim.g.terminal_color_12 = "#7aa2f7"
  -- vim.g.terminal_color_13 = "#bb9af7"
  -- vim.g.terminal_color_14 = "#7dcfff"
  -- vim.g.terminal_color_15 = "#c0caf5"

  -- solazized_osaka_dark
  -- vim.g.terminal_color_0 = "#001419"
  -- vim.g.terminal_color_1 = "#db302d"
  -- vim.g.terminal_color_2 = "#849900"
  -- vim.g.terminal_color_3 = "#b28500"
  -- vim.g.terminal_color_4 = "#268bd3"
  -- vim.g.terminal_color_5 = "#d23681"
  -- vim.g.terminal_color_6 = "#29a298"
  -- vim.g.terminal_color_7 = "#fdf5e2"
  -- vim.g.terminal_color_8 = "#063540"
  -- vim.g.terminal_color_9 = "#f55350"
  -- vim.g.terminal_color_10 = "#b7f900"
  -- vim.g.terminal_color_11 = "#ffbf00"
  -- vim.g.terminal_color_12 = "#46acf5"
  -- vim.g.terminal_color_13 = "#f254a0"
  -- vim.g.terminal_color_14 = "#2aeddd"
  -- vim.g.terminal_color_15 = "#ffffff"
  -- vim.g.neovide_background_color = "#001419"
  -- vim.g.neovide_foreground_color = "#29a298"

  vim.cmd([[autocmd VimEnter * cd ~/github/workspace/]])
end

vim.opt.guicursor = {
  "n-v-c-sm:block-Cursor", -- Use 'Cursor' highlight for normal, visual, and command modes
  "i-ci-ve:ver25-lCursor", -- Use 'lCursor' highlight for insert and visual-exclusive modes
  "r-cr:hor20-CursorIM", -- Use 'CursorIM' for replace mode
}
-- ############################################################################
--                           End of Neovide section
-- ############################################################################
