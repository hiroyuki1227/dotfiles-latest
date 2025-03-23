local trigger_text = ";"

return {
  "saghen/blink.cmp",
  enabled = true,
  dependencies = {
    "moyiz/blink-emoji.nvim",
    "Kaiser-Yang/blink-cmp-dictionary",
    -- add blink.compat to dependencies
    { "saghen/blink.compat", opts = { impersonate_nvim_cmp = true } },
    {
      "Exafunction/codeium.nvim",
      cmd = "Codeium",
      build = ":Codeium Auth",
      opts = { virtual_text = { enabled = true } },
    },
  },
  opts = function(_, opts)
    opts.enabled = function()
      -- Get the current buffer's filetype
      local filetype = vim.bo[0].filetype
      -- Disable for Telescope buffers
      if filetype == "TelescopePrompt" or filetype == "minifiles" or filetype == "snacks_picker_input" then
        return false
      end
      return true
    end

    -- NOTE: The new way to enable LuaSnip
    -- Merge custom sources with the existing ones from lazyvim
    -- NOTE: by default lazyvim already includes the lazydev source, so not adding it here again
    opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
      default = { "lsp", "path", "snippets", "codeinum", "buffer", "cmdline", "emoji", "dictionary" },
      providers = {
        codeium = {
          name = "codeium", -- IMPORTANT: use the same name as you would for nvim-cmp
          module = "blink.compat.source",
          score_offset = 3,
          opts = {
            cache_digraphs_on_start = true,
          },
        },
        lsp = {
          name = "lsp",
          enabled = true,
          module = "blink.cmp.sources.lsp",
          kind = "LSP",
          min_keyword_length = 2,
          score_offset = 90, -- the higher the number, the higher the priority
          opts = { tailwind_color_icon = "██" },
        },
        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          score_offset = 25,
          fallbacks = { "snippets", "buffer" },
          -- min_keyword_length = 2,
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
            get_cwd = function(context)
              return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
            end,
            show_hidden_files_by_default = true,
          },
        },
        buffer = {
          name = "Buffer",
          enabled = true,
          max_items = 3,
          module = "blink.cmp.sources.buffer",
          min_keyword_length = 4,
          score_offset = 15, -- the higher the number, the higher the priority
        },
        snippets = {
          name = "snippets",
          enabled = true,
          max_items = 15,
          min_keyword_length = 2,
          module = "blink.cmp.sources.snippets",
          score_offset = 85, -- the higher the number, the higher the priority
          should_show_items = function()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
            -- NOTE: remember that `trigger_text` is modified at the top of the file
            return before_cursor:match(trigger_text .. "%w*$") ~= nil
          end,
          transform_items = function(_, items)
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
            local trigger_pos = before_cursor:find(trigger_text .. "[^" .. trigger_text .. "]*$")
            if trigger_pos then
              for _, item in ipairs(items) do
                if not item.trigger_text_modified then
                  ---@diagnostic disable-next-line: inject-field
                  item.trigger_text_modified = true
                  item.textEdit = {
                    newText = item.insertText or item.label,
                    range = {
                      start = { line = vim.fn.line(".") - 1, character = trigger_pos - 1 },
                      ["end"] = { line = vim.fn.line(".") - 1, character = col },
                    },
                  }
                end
              end
            end
            return items
          end,
        },
        cmdline = {
          module = "blink.cmp.sources.cmdline",
        },
        emoji = {
          module = "blink-emoji",
          name = "Emoji",
          score_offset = 93, -- the higher the number, the higher the priority
          min_keyword_length = 2,
          opts = { insert = true }, -- Insert emoji (default) or complete its name
        },
        dictionary = {
          module = "blink-cmp-dictionary",
          name = "Dict",
          score_offset = 20, -- the higher the number, the higher the priority
          -- https://github.com/Kaiser-Yang/blink-cmp-dictionary/issues/2
          enabled = true,
          max_items = 8,
          min_keyword_length = 3,
          opts = {
            dictionary_directories = { vim.fn.expand("~/dotfiles/dictionaries") },
            dictionary_files = {
              vim.fn.expand("~/.config/nvim/spell/en.utf-8.add"),
            },
          },
        },
      },
    })

    opts.cmdline = {
      enabled = true,
      keymap = { preset = "cmdline" },
      sources = function()
        local type = vim.fn.getcmdtype()
        --           -- Search forward and backward
        if type == "/" or type == "?" then
          return { "buffer" }
        end
        --           -- Commands
        if type == ":" or type == "@" then
          return { "cmdline" }
        end
        return {}
      end,
      completion = {
        trigger = {
          show_on_blocked_trigger_characters = {},
          show_on_x_blocked_trigger_characters = {},
        },
        list = {
          selection = {
            -- When `true`, will automatically select the first item in the completion list
            preselect = true,
            -- When `true`, inserts the completion item automatically when selecting it
            auto_insert = true,
          },
        },
        -- Whether to automatically show the window when new completion items are available
        menu = { auto_show = true },
        -- Displays a preview of the selected item on the current line
        ghost_text = { enabled = true },
      },
    }

    opts.completion = {
      --   keyword = {
      --     -- 'prefix' will fuzzy match on the text before the cursor
      --     -- 'full' will fuzzy match on the text before *and* after the cursor
      --     -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
      --     range = "full",
      --   },
      menu = {
        border = "single",
      },
      documentation = {
        auto_show = true,
        window = {
          border = "single",
        },
      },
      -- Displays a preview of the selected item on the current line
      ghost_text = {
        enabled = true,
      },
    }

    -- opts.fuzzy = {
    --   -- Disabling this matches the behavior of fzf
    --   use_typo_resistance = false,
    --   -- Frecency tracks the most recently/frequently used items and boosts the score of the item
    --   use_frecency = true,
    --   -- Proximity bonus boosts the score of items matching nearby words
    --   use_proximity = false,
    -- }

    -- opts.snippets = {
    --   preset = "luasnip", -- Choose LuaSnip as the snippet engine
    -- }

    -- -- To specify the options for snippets
    -- opts.sources.providers.snippets.opts = {
    --   use_show_condition = true, -- Enable filtering of snippets dynamically
    --   show_autosnippets = true, -- Display autosnippets in the completion menu
    -- }

    -- The default preset used by lazyvim accepts completions with enter
    -- I don't like using enter because if on markdown and typing
    -- something, but you want to go to the line below, if you press enter,
    -- the completion will be accepted
    -- https://cmp.saghen.dev/configuration/keymap.html#default
    -- The recommended way of getting completions from this plugin. Only requires being enabled with no additional configuration, assuming you have general LSP completions.

    require("render-markdown").setup({
      completions = { blink = { enabled = true } },
    })

    opts.keymap = {
      preset = "default",
      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },

      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },

      ["<S-k>"] = { "scroll_documentation_up", "fallback" },
      ["<S-j>"] = { "scroll_documentation_down", "fallback" },

      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
    }

    return opts
  end,
}
