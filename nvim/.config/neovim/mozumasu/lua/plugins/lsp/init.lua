return {
  -- Disable markdownlint (use rumdl instead via CLI)
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = {},
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    keys = {
      {
        "<leader>cD",
        function()
          local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
          local diagnostics = vim.diagnostic.get(0, { lnum = lnum })
          if #diagnostics == 0 then
            return
          end

          local messages = {}
          for _, d in ipairs(diagnostics) do
            table.insert(messages, string.format("[%s] %s", d.source or "Unknown", d.message))
          end
          local text = table.concat(messages, "\n")

          require("plamo-translate.translate").translate(text, function(result, err)
            if err or not result then
              vim.diagnostic.open_float()
              return
            end
            require("plamo-translate.ui").show(result, { position = "cursor" })
          end)
        end,
        desc = "Line Diagnostics (Translated)",
      },
    },
    opts = {
      diagnostics = {
        virtual_text = {
          format = function(diagnostic)
            -- Add lsp server name to message
            return string.format("%s (%s)", diagnostic.message, diagnostic.source or "Unknown")
          end,
        },
        float = { border = "rounded" },
      },
      inlay_hints = { enabled = false },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "saghen/blink.lib",
      -- optional: provides snippets for the snippet source
      "rafamadriz/friendly-snippets",
    },
    build = function()
      -- build the fuzzy matcher, optionally add a timeout to `pwait(timeout_ms)`
      -- you can use `gb` in `:Lazy` to rebuild the plugin as needed
      require("blink.cmp").build():pwait()
    end,

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { ["<CR>"] = {} },

      -- (Default) Only show the documentation popup when manually triggered
      completion = {
        menu = { border = "rounded" },
        documentation = {
          window = { border = "rounded" },
        },
      },
      cmdline = {
        enabled = true,
        keymap = { preset = "inherit" },
        -- completion = {
        --   ghost_text = { enable = true },
        --   menu = { autoshow = true },
        },
      },

      -- (Default) list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = { default = { "lsp", "path", "snippets", "buffer" } },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"`
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "rust" },
    },
  },
  -- {
  --   "saghen/blink.cmp",
  --   opts = {
  --     completion = {
  --       menu = {
  --         border = "rounded",
  --       },
  --       documentation = {
  --         window = {
  --           border = "rounded",
  --         },
  --       },
  --     },
  --     keymap = {
  --       -- preset = "none",
  --       ["<CR>"] = {}, -- Do not use enter to confirm completion
  --     },
  --     sources = {
  --       default = {
  --         cmdline = {}, -- Disable cmdline completions (conflicts with Snacks picker)
  --       },
  --     },
  --   },
  -- },
}
