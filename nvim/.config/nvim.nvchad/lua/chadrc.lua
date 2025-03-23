--@type ChadrcConfig
local M = {}

M.base46 = {
  -- theme = "solarized_osaka",
  theme = "tokyonight",
  theme_toggle = { "tokyonight", "solarized_osaka" },
  transparency = true,
  styles = {
    sidebars = "transparent",
    floats = "transparent",
  },
  build = function()
    require("base46").load_all_highlights()
  end,
}

M.ui = {
  -- hl_overrides = {
  --   CursorLine = { bg = "one_fg", fg = "one_bg" },
  --   Cursor = { bg = "one_bg", fg = "one_fg" },
  -- },
  statusline = {
    -- enabled = true,
    theme = "default", -- default/vscode/vscode_colored/minimal
    -- theme = "minimal",
    -- round and block will work for minimal theme only
    separator_style = "round", -- default/round/block/arrow
    modules = nil,
    order = nil,
  },

  cmp = {
    icons = true,
    lspkind_text = true,
    style = "atom", -- default/flat_light/flat_dark/atom/atom_colored
    icons_left = true,
    format_colors = {
      tailwind = true,
      icon = "󱓻",
    },
    -- selected_item_bg = "colored", -- colored / simple
    -- border_color = "grey_fg", -- only applicable for "default" style, use color names from base30 variables
  },

  telescope = { style = "borderless" }, -- borderless / bordered

  tabufline = {
    enabled = true,
    lazyload = true,
    order = { "treeOffset", "buffers", "tabs", "btns", "abc" },
    -- modules = nil,
    bufwidth = 21,
    modules = {
      abc = function()
        return "hl"
      end,
    },
  },

  colorify = {
    enabled = true,
    mode = "virtual", -- fg, bg, virtual
    virt_text = "󱓻",
    highlight = { hex = true, lspvars = true },
  },
}

return M
