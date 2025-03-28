-- local colors = require("config.colors")
-- -- Define color variables
-- local color1_bg = colors["linkarzu_color18"]
-- local color2_bg = colors["linkarzu_color19"]
-- local color3_bg = colors["linkarzu_color20"]
-- local color4_bg = colors["linkarzu_color21"]
-- local color5_bg = colors["linkarzu_color22"]
-- local color6_bg = colors["linkarzu_color23"]
-- local color_fg = colors["linkarzu_color10"]
-- local color_sign = "#ebfafa"

return {
  -- {
  --   "OXY2DEV/markview.nvim",
  --   lazy = false, -- Recommended
  --   branch = "dev",
  --   ft = "markdown", -- If you decide to lazy-load anyway
  --
  --   dependencies = {
  --     -- You will not need this if you installed the
  --     -- parsers manually
  --     -- Or if the parsers are in your $RUNTIMEPATH
  --     "nvim-treesitter/nvim-treesitter",
  --     "echasnovski/mini.nvim",
  --     "saghen/blink.cmp",
  --     -- "nvim-tree/nvim-web-devicons",
  --   },
  --
  --   config = function()
  --     -- local presets = require("markview.presets")
  --     require("markview").setup({
  --       markdown = {
  --         code_blocks = {
  --           enable = true,
  --           style = "block", -- "simple" or "block"
  --           sign = true,
  --           label_direction = "right", -- "left" or "right"
  --           border_hl = "MarkviewCode",
  --           info_hl = "MarkviewCodeInfo",
  --           pad_amount = 2,
  --           pad_char = " ",
  --           min_width = 60,
  --           default = {
  --             block_hl = "MarkviewCode",
  --             pad_hl = "MarkviewCode",
  --           },
  --
  --           ["diff"] = {
  --             block_hl = function(_, line)
  --               if line:match("^%+") then
  --                 return "MarkviewPalette4"
  --               elseif line:match("^%-") then
  --                 return "MarkviewPalette1"
  --               else
  --                 return "MarkviewCode"
  --               end
  --             end,
  --             pad_hl = "MarkviewCode",
  --           },
  --         },
  --         -- horizontal_rules = presets.horizontal_rules.thick,
  --         -- tables = presets.tables.rounded,
  --         -- headings
  --         -- Accessed using require("markview.presets").headings.
  --         -- glow/glow_center/slanted/arrowed/simple/marker
  --         -- https://github.com/OXY2DEV/markview.nvim/wiki/Presets
  --         -- headings = presets.headings.glow,
  --       },
  --     })
  --     -- vim.cmd(string.format([[highlight MarkviewHeading1 guibg=%s guifg=%s]], color1_bg, color_fg))
  --     -- vim.cmd(string.format([[highlight MarkviewHeading2 guibg=%s guifg=%s]], color2_bg, color_fg))
  --     -- vim.cmd(string.format([[highlight MarkviewHeading3 guibg=%s guifg=%s]], color3_bg, color_fg))
  --     -- vim.cmd(string.format([[highlight MarkviewHeading4 guibg=%s guifg=%s]], color4_bg, color_fg))
  --     -- vim.cmd(string.format([[highlight MarkviewHeading5 guibg=%s guifg=%s]], color5_bg, color_fg))
  --     -- vim.cmd(string.format([[highlight MarkviewHeading6 guibg=%s guifg=%s]], color6_bg, color_fg))
  --     -- vim.cmd([[highlight MarkviewCode guibg=#1e2326]])
  --
  --     -- vim.cmd([[highlight MarkviewHeading1 guibg=#E67E80 guifg=white]])
  --     -- vim.cmd([[highlight MarkviewHeading2 guibg=#EB9C5F guifg=white]])
  --     -- vim.cmd([[highlight MarkviewHeading3 guibg=#83C092 guifg=white]])
  --     -- vim.cmd([[highlight MarkviewHeading4 guibg=#7FBBB3 guifg=white]])
  --     -- vim.cmd([[highlight MarkviewHeading5 guibg=#D3C6AA guifg=white]])
  --     -- vim.cmd([[highlight MarkviewHeading6 guibg=#384B55 guifg=white]])
  --     -- vim.cmd([[highlight MarkviewCode guibg=#1e2326]])
  --   end,
  -- },
  {
    -- Install markdown preview, use npx if available.
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function(plugin)
      if vim.fn.executable("npx") then
        vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
      else
        vim.cmd([[Lazy load markdown-preview.nvim]])
        vim.fn["mkdp#util#install"]()
      end
    end,
    init = function()
      if vim.fn.executable("npx") then
        vim.g.mkdp_filetypes = { "markdown" }
      end
    end,
    keys = {
      { "<leader>msp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview Toggle" },
      { "<leader>mss", "<cmd>MarkdownPreview<cr>", desc = "Markdown Preview" },
      { "<leader>msx", "<cmd>MarkdownPreviewStop<cr>", desc = "Markdown Preview Stop" },
    },
  },
}
