-- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/plugins/render-markdown.lua
-- ~/github/dotfiles-latest/neovim/neobean/lua/plugins/render-markdown.lua

-- https://github.com/MeanderingProgrammer/markdown.nvim
--
-- When I hover over markdown headings, this plugins goes away, so I need to
-- edit the default highlights
-- I tried adding this as an autocommand, in the options.lua
-- file, also in the markdownl.lua file, but the highlights kept being overriden
-- so the only way I was able to make it work was loading it
-- after the config.lazy in the init.lua file lamw25wmal

return {
  "MeanderingProgrammer/render-markdown.nvim",
  enabled = true,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ---@module 'render-markdown'
  ft = { "markdown", "norg", "rmd", "org" },
  init = function()
    -- Define colors
    local color1_bg = "#ff757f"
    local color2_bg = "#4fd6be"
    local color3_bg = "#7dcfff"
    local color4_bg = "#ff9e64"
    local color5_bg = "#7aa2f7"
    local color6_bg = "#c0caf5"
    local color_fg = "#1F2335"

    -- Heading background
    vim.cmd(string.format([[highlight Headline1Bg guifg=%s guibg=%s gui=bold]], color_fg, color1_bg))
    vim.cmd(string.format([[highlight Headline2Bg guifg=%s guibg=%s gui=bold]], color_fg, color2_bg))
    vim.cmd(string.format([[highlight Headline3Bg guifg=%s guibg=%s gui=bold]], color_fg, color3_bg))
    vim.cmd(string.format([[highlight Headline4Bg guifg=%s guibg=%s gui=bold]], color_fg, color4_bg))
    vim.cmd(string.format([[highlight Headline5Bg guifg=%s guibg=%s gui=bold]], color_fg, color5_bg))
    vim.cmd(string.format([[highlight Headline6Bg guifg=%s guibg=%s gui=bold]], color_fg, color6_bg))

    -- Heading fg
    -- vim.cmd(string.format([[highlight Headline1Fg guifg=%s gui=bold]], colors.color1_bg))
    -- vim.cmd(string.format([[highlight Headline2Fg guifg=%s gui=bold]], colors.color2_bg))
    -- vim.cmd(string.format([[highlight Headline3Fg guifg=%s gui=bold]], colors.color3_bg))
    -- vim.cmd(string.format([[highlight Headline4Fg guifg=%s gui=bold]], colors.color4_bg))
    -- vim.cmd(string.format([[highlight Headline5Fg guifg=%s gui=bold]], colors.color5_bg))
    -- vim.cmd(string.format([[highlight Headline6Fg guifg=%s gui=bold]], colors.color6_bg))

    -- force treesitter highlighting for markdown buffers
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
  opts = {
    restart_highlighter = true,
    heading = {
      sign = false,
      icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
      backgrounds = {
        "Headline1Bg",
        "Headline2Bg",
        "Headline3Bg",
        "Headline4Bg",
        "Headline5Bg",
        "Headline6Bg",
      },
      foregrounds = {
        "Headline1Fg",
        "Headline2Fg",
        "Headline3Fg",
        "Headline4Fg",
        "Headline5Fg",
        "Headline6Fg",
      },
    },
    code = {
      sign = "full",
      -- width = "block",
      -- right_pad = 1,
    },
    bullet = {
      -- Turn on / off list bullet rendering
      enabled = true,
    },
    checkbox = {
      -- Turn on / off checkbox state rendering
      enabled = true,
      unchecked = {
        -- Replaces '[ ]' of 'task_list_marker_unchecked'
        icon = "   󰄱 ",
        -- Highlight for the unchecked icon
        highlight = "RenderMarkdownUnchecked",
        -- Highlight for item associated with unchecked checkbox
        scope_highlight = nil,
      },
      checked = {
        -- Replaces '[x]' of 'task_list_marker_checked'
        icon = "   󰱒 ",
        -- Highlight for the checked icon
        highlight = "RenderMarkdownChecked",
        -- Highlight for item associated with checked checkbox
        scope_highlight = nil,
      },
    },
    html = {
      comment = {
        conceal = false,
      },
    },
  },
}

-- return {
--   "MeanderingProgrammer/render-markdown.nvim",
--   enabled = true,
--   -- Moved highlight creation out of opts as suggested by plugin maintainer
--   -- There was no issue, but it was creating unnecessary noise when ran
--   -- :checkhealth render-markdown
--   -- https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/138#issuecomment-2295422741
--   opts = {
--     -- ignore = function(buf)
--     -- 	return vim.api.nvim_buf_get_name(buf):match("fffile preview$") ~= nil
--     -- end,
--     bullet = {
--       -- Turn on / off list bullet rendering
--       enabled = true,
--     },
--     checkbox = {
--       -- Turn on / off checkbox state rendering
--       enabled = true,
--       -- Determines how icons fill the available space:
--       --  inline:  underlying text is concealed resulting in a left aligned icon
--       --  overlay: result is left padded with spaces to hide any additional text
--       position = "inline",
--       unchecked = {
--         -- Replaces '[ ]' of 'task_list_marker_unchecked'
--         icon = "   󰄱 ",
--         -- Highlight for the unchecked icon
--         highlight = "RenderMarkdownUnchecked",
--         -- Highlight for item associated with unchecked checkbox
--         scope_highlight = nil,
--       },
--       checked = {
--         -- Replaces '[x]' of 'task_list_marker_checked'
--         icon = "   󰱒 ",
--         -- Highlight for the checked icon
--         highlight = "RenderMarkdownChecked",
--         -- Highlight for item associated with checked checkbox
--         scope_highlight = nil,
--       },
--     },
--     html = {
--       -- Turn on / off all HTML rendering
--       enabled = true,
--       comment = {
--         -- Turn on / off HTML comment concealing
--         conceal = false,
--       },
--     },
--     -- Add custom icons lamw26wmal
--     -- link = {
--     --   image = vim.g.neovim_mode == "skitty" and "" or "󰥶 ",
--     --   custom = {
--     --     youtu = { pattern = "youtu%.be", icon = "󰗃 " },
--     --   },
--     -- },
--     heading = {
--       sign = true,
--       icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
--       backgrounds = {
--         "Headline1Bg",
--         "Headline2Bg",
--         "Headline3Bg",
--         "Headline4Bg",
--         "Headline5Bg",
--         "Headline6Bg",
--       },
--       foregrounds = {
--         "Headline1Fg",
--         "Headline2Fg",
--         "Headline3Fg",
--         "Headline4Fg",
--         "Headline5Fg",
--         "Headline6Fg",
--       },
--     },
--     code = {
--       -- if I'm not using yabai, I cannot make the color of the codeblocks
--       -- transparent, so just disabling all rendering 😢
--       style = "full",
--     },
--   },
-- }
