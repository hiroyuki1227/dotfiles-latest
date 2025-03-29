return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "moyiz/blink-emoji.nvim",
  },
  version = "1.*", -- build from source
  -- @module 'blink.cmp'
  -- @type blink.cmp.Config
  opts = {
    completion = {
      list = {
        selection = {
          auto_insert = true,
          preselect = true,
        },
      },
      menu = {
        winblend = vim.o.pumblend,
        border = "rounded",
      },
      documentation = {
        auto_show = true, -- auto show documentation
        window = {
          border = "rounded",
        },
      },
    },
    signature = {
      enabled = true,
      window = {
        winblend = vim.o.pumblend,
      },
    },
    -- keymap = { preset = "default" },
    --
    appearance = {
      nerd_font_variant = "mono",
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer", "emoji" },
      providers = {
        emoji = {
          module = "blink-emoji",
          name = "Emoji",
          score_offset = 15, -- tune by preference
          opts = { insert = true }, -- Insert emoji (default) or complete its name
          should_show_items = function()
            return vim.tbl_contains(
              -- Enable emoji completion only for git commits and markdown.
              -- By default, enabled for all file-types.
              { "gitcommit", "markdown" },
              vim.o.filetype
            )
          end,
        },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
