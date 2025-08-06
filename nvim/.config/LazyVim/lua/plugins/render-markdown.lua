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

-- Require the colors.lua module and access the colors directly without
-- additional file reads
local colors = require("config.colors")
-- return {
--   "MeanderingProgrammer/render-markdown.nvim",
--   enabled = true,
--   ft = {
--     "markdown",
--     "markdown.mdx",
--     "Avante",
--     "codecompanion",
--   },
--
--   -- Moved highlight creation out of opts as suggested by plugin maintainer
--   -- There was no issue, but it was creating unnecessary noise when ran
--   -- :checkhealth render-markdown
--   -- https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/138#issuecomment-2295422741
--   init = function()
--     local colorInline_bg = colors["linkarzu_color02"]
--     local color_fg = colors["linkarzu_color26"]
--     -- local color_sign = "#ebfafa"
--     if vim.g.md_heading_bg == "transparent" then
--       -- Define color variables
--       local color1_bg = colors["linkarzu_color04"]
--       local color2_bg = colors["linkarzu_color02"]
--       local color3_bg = colors["linkarzu_color03"]
--       local color4_bg = colors["linkarzu_color01"]
--       local color5_bg = colors["linkarzu_color05"]
--       local color6_bg = colors["linkarzu_color08"]
--       local color_fg1 = colors["linkarzu_color18"]
--       local color_fg2 = colors["linkarzu_color19"]
--       local color_fg3 = colors["linkarzu_color20"]
--       local color_fg4 = colors["linkarzu_color21"]
--       local color_fg5 = colors["linkarzu_color22"]
--       local color_fg6 = colors["linkarzu_color23"]
--
--       -- Heading colors (when not hovered over), extends through the entire line
--       vim.cmd(string.format([[highlight Headline1Bg guibg=%s guifg=%s ]], color_fg1, color1_bg))
--       vim.cmd(string.format([[highlight Headline2Bg guibg=%s guifg=%s ]], color_fg2, color2_bg))
--       vim.cmd(string.format([[highlight Headline3Bg guibg=%s guifg=%s ]], color_fg3, color3_bg))
--       vim.cmd(string.format([[highlight Headline4Bg guibg=%s guifg=%s ]], color_fg4, color4_bg))
--       vim.cmd(string.format([[highlight Headline5Bg guibg=%s guifg=%s ]], color_fg5, color5_bg))
--       vim.cmd(string.format([[highlight Headline6Bg guibg=%s guifg=%s ]], color_fg6, color6_bg))
--       -- Define inline code highlight for markdown
--       vim.cmd(string.format([[highlight RenderMarkdownCodeInline guifg=%s guibg=%s]], colorInline_bg, color_fg))
--       -- vim.cmd(string.format([[highlight RenderMarkdownCodeInline guifg=%s]], colorInline_bg))
--
--       -- Highlight for the heading and sign icons (symbol on the left)
--       -- I have the sign disabled for now, so this makes no effect
--       vim.cmd(string.format([[highlight Headline1Fg cterm=bold gui=bold guifg=%s]], color1_bg))
--       vim.cmd(string.format([[highlight Headline2Fg cterm=bold gui=bold guifg=%s]], color2_bg))
--       vim.cmd(string.format([[highlight Headline3Fg cterm=bold gui=bold guifg=%s]], color3_bg))
--       vim.cmd(string.format([[highlight Headline4Fg cterm=bold gui=bold guifg=%s]], color4_bg))
--       vim.cmd(string.format([[highlight Headline5Fg cterm=bold gui=bold guifg=%s]], color5_bg))
--       vim.cmd(string.format([[highlight Headline6Fg cterm=bold gui=bold guifg=%s]], color6_bg))
--     else
--       local color1_bg = colors["linkarzu_color18"]
--       local color2_bg = colors["linkarzu_color19"]
--       local color3_bg = colors["linkarzu_color20"]
--       local color4_bg = colors["linkarzu_color21"]
--       local color5_bg = colors["linkarzu_color22"]
--       local color6_bg = colors["linkarzu_color23"]
--       vim.cmd(string.format([[highlight Headline1Bg guifg=%s guibg=%s]], color_fg, color1_bg))
--       vim.cmd(string.format([[highlight Headline2Bg guifg=%s guibg=%s]], color_fg, color2_bg))
--       vim.cmd(string.format([[highlight Headline3Bg guifg=%s guibg=%s]], color_fg, color3_bg))
--       vim.cmd(string.format([[highlight Headline4Bg guifg=%s guibg=%s]], color_fg, color4_bg))
--       vim.cmd(string.format([[highlight Headline5Bg guifg=%s guibg=%s]], color_fg, color5_bg))
--       vim.cmd(string.format([[highlight Headline6Bg guifg=%s guibg=%s]], color_fg, color6_bg))
--     end
--   end,
--   opts = {
--     file_type = { "markdown", "Avante", "codecompanion" },
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
--       code = {
--         border = "thick",
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
--     link = {
--       image = vim.g.neovim_mode == "skitty" and "" or "󰥶 ",
--       custom = {
--         youtu = { pattern = "youtu%.be", icon = "󰗃 " },
--       },
--     },
--     heading = {
--       sign = false,
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
--     -- code = {
--     --   style = "none",
--     -- },
--   },
-- }
--
return {
  require("render-markdown").setup({
    link = {
      -- Turn on / off inline link icon rendering.
      enabled = true,
      -- Additional modes to render links.
      render_modes = false,
      -- How to handle footnote links, start with a '^'.
      footnote = {
        -- Turn on / off footnote rendering.
        enabled = true,
        -- Replace value with superscript equivalent.
        superscript = true,
        -- Added before link content.
        prefix = "",
        -- Added after link content.
        suffix = "",
      },
      -- Inlined with 'image' elements.
      image = "󰥶 ",
      -- Inlined with 'email_autolink' elements.
      email = "󰀓 ",
      -- Fallback icon for 'inline_link' and 'uri_autolink' elements.
      hyperlink = "󰌹 ",
      -- Applies to the inlined icon as a fallback.
      highlight = "RenderMarkdownLink",
      -- Applies to WikiLink elements.
      wiki = {
        icon = "󱗖 ",
        body = function()
          return nil
        end,
        highlight = "RenderMarkdownWikiLink",
      },
      -- Define custom destination patterns so icons can quickly inform you of what a link
      -- contains. Applies to 'inline_link', 'uri_autolink', and wikilink nodes. When multiple
      -- patterns match a link the one with the longer pattern is used.
      -- The key is for healthcheck and to allow users to change its values, value type below.
      -- | pattern   | matched against the destination text                            |
      -- | icon      | gets inlined before the link text                               |
      -- | kind      | optional determines how pattern is checked                      |
      -- |           | pattern | @see :h lua-patterns, is the default if not set       |
      -- |           | suffix  | @see :h vim.endswith()                                |
      -- | priority  | optional used when multiple match, uses pattern length if empty |
      -- | highlight | optional highlight for 'icon', uses fallback highlight if empty |
      custom = {
        web = { pattern = "^http", icon = "󰖟 " },
        github = { pattern = "github%.com", icon = "󰊤 " },
        gitlab = { pattern = "gitlab%.com", icon = "󰮠 " },
        stackoverflow = { pattern = "stackoverflow%.com", icon = "󰓌 " },
        wikipedia = { pattern = "wikipedia%.org", icon = "󰖬 " },
        youtube = { pattern = "youtube%.com", icon = "󰗃 " },
      },
    },
    -- init = function()
    --   local colorInline_bg = colors["linkarzu_color02"]
    --   local color_fg = colors["linkarzu_color26"]
    --   -- local color_sign = "#ebfafa"
    --   if vim.g.md_heading_bg == "transparent" then
    --     -- Define color variables
    --     local color1_bg = colors["linkarzu_color04"]
    --     local color2_bg = colors["linkarzu_color02"]
    --     local color3_bg = colors["linkarzu_color03"]
    --     local color4_bg = colors["linkarzu_color01"]
    --     local color5_bg = colors["linkarzu_color05"]
    --     local color6_bg = colors["linkarzu_color08"]
    --     local color_fg1 = colors["linkarzu_color18"]
    --     local color_fg2 = colors["linkarzu_color19"]
    --     local color_fg3 = colors["linkarzu_color20"]
    --     local color_fg4 = colors["linkarzu_color21"]
    --     local color_fg5 = colors["linkarzu_color22"]
    --     local color_fg6 = colors["linkarzu_color23"]
    --
    --     -- Heading colors (when not hovered over), extends through the entire line
    --     vim.cmd(string.format([[highlight Headline1Bg guibg=%s guifg=%s ]], color_fg1, color1_bg))
    --     vim.cmd(string.format([[highlight Headline2Bg guibg=%s guifg=%s ]], color_fg2, color2_bg))
    --     vim.cmd(string.format([[highlight Headline3Bg guibg=%s guifg=%s ]], color_fg3, color3_bg))
    --     vim.cmd(string.format([[highlight Headline4Bg guibg=%s guifg=%s ]], color_fg4, color4_bg))
    --     vim.cmd(string.format([[highlight Headline5Bg guibg=%s guifg=%s ]], color_fg5, color5_bg))
    --     vim.cmd(string.format([[highlight Headline6Bg guibg=%s guifg=%s ]], color_fg6, color6_bg))
    --     -- Define inline code highlight for markdown
    --     vim.cmd(string.format([[highlight RenderMarkdownCodeInline guifg=%s guibg=%s]], colorInline_bg, color_fg))
    --     -- vim.cmd(string.format([[highlight RenderMarkdownCodeInline guifg=%s]], colorInline_bg))
    --
    --     -- Highlight for the heading and sign icons (symbol on the left)
    --     -- I have the sign disabled for now, so this makes no effect
    --     vim.cmd(string.format([[highlight Headline1Fg cterm=bold gui=bold guifg=%s]], color1_bg))
    --     vim.cmd(string.format([[highlight Headline2Fg cterm=bold gui=bold guifg=%s]], color2_bg))
    --     vim.cmd(string.format([[highlight Headline3Fg cterm=bold gui=bold guifg=%s]], color3_bg))
    --     vim.cmd(string.format([[highlight Headline4Fg cterm=bold gui=bold guifg=%s]], color4_bg))
    --     vim.cmd(string.format([[highlight Headline5Fg cterm=bold gui=bold guifg=%s]], color5_bg))
    --     vim.cmd(string.format([[highlight Headline6Fg cterm=bold gui=bold guifg=%s]], color6_bg))
    --   else
    --     local color1_bg = colors["linkarzu_color18"]
    --     local color2_bg = colors["linkarzu_color19"]
    --     local color3_bg = colors["linkarzu_color20"]
    --     local color4_bg = colors["linkarzu_color21"]
    --     local color5_bg = colors["linkarzu_color22"]
    --     local color6_bg = colors["linkarzu_color23"]
    --     vim.cmd(string.format([[highlight Headline1Bg guifg=%s guibg=%s]], color_fg, color1_bg))
    --     vim.cmd(string.format([[highlight Headline2Bg guifg=%s guibg=%s]], color_fg, color2_bg))
    --     vim.cmd(string.format([[highlight Headline3Bg guifg=%s guibg=%s]], color_fg, color3_bg))
    --     vim.cmd(string.format([[highlight Headline4Bg guifg=%s guibg=%s]], color_fg, color4_bg))
    --     vim.cmd(string.format([[highlight Headline5Bg guifg=%s guibg=%s]], color_fg, color5_bg))
    --     vim.cmd(string.format([[highlight Headline6Bg guifg=%s guibg=%s]], color_fg, color6_bg))
    --   end
    -- end,
    file_type = { "markdown", "Avante", "codecompanion" },
    heading = {
      sign = false,
      icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
      -- backgrounds = {
      --   "Headline1Bg",
      --   "Headline2Bg",
      --   "Headline3Bg",
      --   "Headline4Bg",
      --   "Headline5Bg",
      --   "Headline6Bg",
      -- },
      -- foregrounds = {
      --   "Headline1Fg",
      --   "Headline2Fg",
      --   "Headline3Fg",
      --   "Headline4Fg",
      --   "Headline5Fg",
      --   "Headline6Fg",
      -- },
    },
    callout = {
      -- Callouts are a special instance of a 'block_quote' that start with a 'shortcut_link'.
      -- The key is for healthcheck and to allow users to change its values, value type below.
      -- | raw        | matched against the raw text of a 'shortcut_link', case insensitive |
      -- | rendered   | replaces the 'raw' value when rendering                             |
      -- | highlight  | highlight for the 'rendered' text and quote markers                 |
      -- | quote_icon | optional override for quote.icon value for individual callout       |
      -- | category   | optional metadata useful for filtering                              |

      note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
      tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
      important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
      warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
      caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
      abstract = { raw = "[!ABSTRACT]", rendered = "󰨸 Abstract", highlight = "RenderMarkdownInfo" },
      summary = { raw = "[!SUMMARY]", rendered = "󰨸 Summary", highlight = "RenderMarkdownInfo" },
      tldr = { raw = "[!TLDR]", rendered = "󰨸 Tldr", highlight = "RenderMarkdownInfo" },
      info = { raw = "[!INFO]", rendered = "󰋽 Info", highlight = "RenderMarkdownInfo" },
      todo = { raw = "[!TODO]", rendered = "󰗡 Todo", highlight = "RenderMarkdownInfo" },
      hint = { raw = "[!HINT]", rendered = "󰌶 Hint", highlight = "RenderMarkdownSuccess" },
      success = { raw = "[!SUCCESS]", rendered = "󰄬 Success", highlight = "RenderMarkdownSuccess" },
      check = { raw = "[!CHECK]", rendered = "󰄬 Check", highlight = "RenderMarkdownSuccess" },
      done = { raw = "[!DONE]", rendered = "󰄬 Done", highlight = "RenderMarkdownSuccess" },
      question = { raw = "[!QUESTION]", rendered = "󰘥 Question", highlight = "RenderMarkdownWarn" },
      help = { raw = "[!HELP]", rendered = "󰘥 Help", highlight = "RenderMarkdownWarn" },
      faq = { raw = "[!FAQ]", rendered = "󰘥 Faq", highlight = "RenderMarkdownWarn" },
      attention = { raw = "[!ATTENTION]", rendered = "󰀪 Attention", highlight = "RenderMarkdownWarn" },
      failure = { raw = "[!FAILURE]", rendered = "󰅖 Failure", highlight = "RenderMarkdownError" },
      fail = { raw = "[!FAIL]", rendered = "󰅖 Fail", highlight = "RenderMarkdownError" },
      missing = { raw = "[!MISSING]", rendered = "󰅖 Missing", highlight = "RenderMarkdownError" },
      danger = { raw = "[!DANGER]", rendered = "󱐌 Danger", highlight = "RenderMarkdownError" },
      error = { raw = "[!ERROR]", rendered = "󱐌 Error", highlight = "RenderMarkdownError" },
      bug = { raw = "[!BUG]", rendered = "󰨰 Bug", highlight = "RenderMarkdownError" },
      example = { raw = "[!EXAMPLE]", rendered = "󰉹 Example", highlight = "RenderMarkdownHint" },
      quote = { raw = "[!QUOTE]", rendered = "󱆨 Quote", highlight = "RenderMarkdownQuote" },
      cite = { raw = "[!CITE]", rendered = "󱆨 Cite", highlight = "RenderMarkdownQuote" },
    },
    checkbox = {
      enabled = true,
      render_modes = false,
      bullet = false,
      right_pad = 1,
      unchecked = {
        icon = "󰄱 ",
        highlight = "RenderMarkdownUnchecked",
        scope_highlight = nil,
      },
      checked = {
        icon = "󰱒 ",
        highlight = "RenderMarkdownChecked",
        scope_highlight = nil,
      },
      custom = {
        todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
      },
    },
    bullet = {
      enabled = true,
      render_modes = false,
      icons = { "●", "○", "◆", "◇" },
      ordered_icons = function(ctx)
        local value = vim.trim(ctx.value)
        local index = tonumber(value:sub(1, #value - 1))
        return ("%d."):format(index > 1 and index or ctx.index)
      end,
      left_pad = 0,
      right_pad = 0,
      highlight = "RenderMarkdownBullet",
      scope_highlight = {},
    },
    quote = { icon = "▋" },
    anti_conceal = {
      enabled = true,
      -- Which elements to always show, ignoring anti conceal behavior. Values can either be
      -- booleans to fix the behavior or string lists representing modes where anti conceal
      -- behavior will be ignored. Valid values are:
      --   head_icon, head_background, head_border, code_language, code_background, code_border,
      --   dash, bullet, check_icon, check_scope, quote, table_border, callout, link, sign
      ignore = {
        code_background = true,
        sign = true,
      },
      above = 0,
      below = 0,
    },
  }),
}
