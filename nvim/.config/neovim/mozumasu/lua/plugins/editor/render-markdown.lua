return {
  "MeanderingProgrammer/render-markdown.nvim",
  enabled = true,
  -- Moved highlight creation out of opts as suggested by plugin maintainer
  -- There was no issue, but it was creating unnecessary noise when ran
  -- :checkhealth render-markdown
  -- https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/138#issuecomment-2295422741
  ft = { "markdown" },
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
  opts = {
    bullet = {
      -- Turn on / off list bullet rendering
      enabled = true,
    },
    -- checkbox = {
    --   -- Turn on / off checkbox state rendering
    --   enabled = true,
    --   -- Determines how icons fill the available space:
    --   --  inline:  underlying text is concealed resulting in a left aligned icon
    --   --  overlay: result is left padded with spaces to hide any additional text
    --   position = "inline",
    --   unchecked = {
    --     -- Replaces '[ ]' of 'task_list_marker_unchecked'
    --     icon = "   󰄱 ",
    --     -- Highlight for the unchecked icon
    --     highlight = "RenderMarkdownUnchecked",
    --     -- Highlight for item associated with unchecked checkbox
    --     scope_highlight = nil,
    --   },
    --   checked = {
    --     -- Replaces '[x]' of 'task_list_marker_checked'
    --     icon = "   󰱒 ",
    --     -- Highlight for the checked icon
    --     highlight = "RenderMarkdownChecked",
    --     -- Highlight for item associated with checked checkbox
    --     scope_highlight = nil,
    --   },
    -- },
    html = {
      -- Turn on / off all HTML rendering
      enabled = true,
      comment = {
        -- Turn on / off HTML comment concealing
        conceal = false,
      },
    },
    heading = {
      sign = false,
      icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
      -- backgrounds = {
      --   "RenderMarkdownH1Bg",
      --   "RenderMarkdownH2Bg",
      --   "RenderMarkdownH3Bg",
      --   "RenderMarkdownH4Bg",
      --   "RenderMarkdownH5Bg",
      --   "RenderMarkdownH6Bg",
      -- },
      -- foregrounds = {
      --   "RenderMarkdownH1",
      --   "RenderMarkdownH2",
      --   "RenderMarkdownH3",
      --   "RenderMarkdownH4",
      --   "RenderMarkdownH5",
      --   "RenderMarkdownH6",
      -- },
    },
    code = {
      -- if I'm not using yabai, I cannot make the color of the codeblocks
      -- transparent, so just disabling all rendering 😢
      style = "full",
    },
  },
}
