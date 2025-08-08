-- local icons = require("lib.icons")
return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "moyiz/blink-emoji.nvim",
      "MahanRahmati/blink-nerdfont.nvim",
      "Kaiser-Yang/blink-cmp-dictionary",
      -- "Kaiser-Yang/blink-cmp-avante",
      -- { "saghen/blink.compat", opts = { enable_events = true } },
      -- {
      --   "Exafunction/codeium.nvim",
      --   dependencies = {
      --     "nvim-lua/plenary.nvim",
      --   },
      --   opts = {},
      -- },
    },

    version = "*", -- build from source
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
          winblend = 0,
          -- winblend = vim.o.pumblend,
          border = "rounded",
        },
        documentation = {
          auto_show = true, -- auto show documentation
          auto_show_delay_ms = 500,

          window = {
            border = "rounded",
            winblend = 0,
          },
        },
        -- ghost_text = { enabled = true },
      },
      signature = {
        enabled = true,
        window = {
          winblend = vim.o.pumblend,
          border = "rounded",
        },
      },
      -- keymap = { preset = "default" },
      --
      appearance = {
        use_nvim_cmp_as_default = true,
        -- kind_icon = icons.kind,
        nerd_font_variant = "normal",
      },

      -- NOTE: For the emoji definitions make sure "emoji" is installed
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer", "emoji", "dictionary", "nerdfont" },
        providers = {
          -- avante = {
          --   module = "blink-cmp-avante",
          --   name = "avante",
          --   command = {
          --     get_kind_name = function(_)
          --       return "AvanteCmd"
          --     end,
          --   },
          --   mention = {
          --     get_kind_name = function(_)
          --       return "AvanteMention"
          --     end,
          --   },
          --   kind_icons = {
          --     AvanteCmd = "",
          --     AvanteMention = "",
          --   },
          --   opts = {},
          -- },
          -- codeium = {
          --   name = "codeium",
          --   module = "blink.compat.source",
          --   score_offset = 3,
          --   opts = {},
          -- },
          -- TODO:
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            score_offset = 98, -- tune by preference
            min_keyword_length = 2,
            opts = { insert = true }, -- Insert emoji (default) or complete its name
            should_show_items = function()
              return vim.tbl_contains(
                -- Enable emoji completion only for git commits and markdown.
                -- By default, enabled for all file-types.
                -- emojiはmarkdownファイルとgitcommitするときに利用できる
                -- ":"を入力してemojiのキーワードを入れる。
                --
                { "lua", "gitcommit", "markdown", "text", "plaintex", "typst", "toml", "yaml", "json" },
                vim.o.filetype
              )
            end,
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = -1000,
          },
          -- TODO:
          nerdfont = { -- keymap - insert mode at key is ":"
            module = "blink-nerdfont",
            name = "Nerd Font",
            score_offset = 98, -- tune by preference
            opts = { insert = true }, -- insert nerdfopnt icon (default) or complete its name
          },
          -- NOTE: For the word definitions make sure "wn" is installed
          -- brew install wordnet
          -- https://github.com/Kaiser-Yang/blink-cmp-dictionary
          dictionary = {
            enabled = true,
            module = "blink-cmp-dictionary",
            name = "Dict",
            score_offset = -1000, -- the higher the number, the higher the priority
            max_items = 8,
            async = true,
            min_keyword_length = 3,
            opts = {
              -- -- The dictionary by default now uses fzf, make sure to have it
              -- -- installed
              -- -- https://github.com/Kaiser-Yang/blink-cmp-dictionary/issues/2
              --
              -- Do not specify a file, just the path, and in the path you need to
              -- have your .txt files
              dictionary_directories = { vim.fn.expand("~/dotfiles/dictionaries") },
              -- Notice I'm also adding the words I add to the spell dictionary
              dictionary_files = {
                vim.fn.expand("~/.config/LazyVim/spell/en.utf-8.add"),
              },
              -- --  NOTE: To disable the definitions uncomment this section below
              --
              -- separate_output = function(output)
              --   local items = {}
              --   for line in output:gmatch("[^\r\n]+") do
              --     table.insert(items, {
              --       label = line,
              --       insert_text = line,
              --       documentation = nil,
              --     })
              --   end
              --   return items
              -- end,
            },
          },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },

  -- {
  --   -- Explicit configuration for blink-cmp-avante
  --   {
  --     "Kaiser-Yang/blink-cmp-avante",
  --     lazy = false,
  --     dependencies = {
  --       "yetone/avante.nvim",
  --       "saghen/blink.cmp",
  --     },
  --     opts = {
  --       -- add Avante here
  --       avante = {
  --         command = {
  --           get_kind_name = function(_)
  --             return "AvanteCmd"
  --           end,
  --         },
  --         mention = {
  --           get_kind_name = function(_)
  --             return "AvanteMention"
  --           end,
  --         },
  --       },
  --       kind_icons = {
  --         AvanteCmd = "",
  --         AvanteMention = "",
  --       },
  --     },
  --     config = function()
  --       vim.schedule(function()
  --         vim.notify("blink-cmp-avante loaded", vim.log.levels.INFO)
  --       end)
  --     end,
  --   },
  -- },
}
