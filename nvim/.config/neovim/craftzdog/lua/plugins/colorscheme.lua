return {
  {
    "craftzdog/solarized-osaka.nvim",
    branch = "main",
    lazy = true, -- Load on startup
    priority = 1000,
    opts = {
      transparent = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = "transparent",
        floats = "transparent",
      },
      sidebars = { "qf", "help" },
      day_brightness = 0.3,
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = false,
      on_highlights = function(hl, c)
        hl.Pmenu = { fg = c.base0, bg = c.none }
        hl.BlinkCmpMenu = { fg = c.base01, bg = c.none }
      end,
    },
    -- "craftzdog/solarized-osaka.nvim",
    -- lazy = true,
    -- priority = 1000,
    -- opts = function()
    -- 	return {
    -- 		transparent = true,
    -- 	}
    -- end,
  },
}
