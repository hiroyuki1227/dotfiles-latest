return {
  -- messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    event = { "VeryLazy" },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "ibhagwan/fzf-lua",
    },
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })
      table.insert(opts.routes, 1, {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = "notify_send",
        opts = { stop = false },
      })

      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })

      opts.notify = {
        -- Noice can be used as `vim.notify` so you can route any notification like other messages
        -- Notification messages have their level and other properties set.
        -- event is always "notify" and kind can be any log level as a string
        -- The default routes will forward notifications to nvim-notify
        -- Benefit of using Noice for this is the routing and consistent history view
        enabled = true,
        view = "notify",
      }
      opts.messages = {
        -- NOTE: If you enable messages, then the cmdline is enabled automatically.
        -- This is a current Neovim limitation.
        enabled = true, -- enables the Noice messages UI
        view = "notify", -- default view for messages
        view_warn = "notify", -- view for warnings
        view_error = "notify", -- view for errors
        view_history = "messages", -- view for :messages
        view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
      }
      opts.redirect = {
        view = "popup",
        filter = { event = "msg_show" },
      }
      opts.presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      }
      opts.lsp = {
        messages = {
          enabled = true,
          view = "notify",
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
        signature = { enabled = true },
      }
      opts.views = {
        cmdline_popup = {
          position = {
            row = "40%",
            col = "50%",
          },
          size = {
            width = 60,
            height = "auto",
          },
        },
        popupmenu = {
          relative = "editor",
          position = {
            row = 8,
            col = "50%",
          },
          size = {
            width = 60,
            height = 10,
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
          },
        },
        mini = {
          timeout = 5000,
          align = "center",
          position = {
            row = "95%",
            col = "100%",
          },
        },
      }
    end,
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 5000,
    },
  },
  {
    "crnvl96/lazydocker.nvim",
    event = "VeryLazy",
    opts = {}, -- automatically calls `require("lazydocker").setup()`
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    vim.keymap.set("n", "<leader>dd", "<cmd>LazyDocker<CR>", { desc = "Toggle LazyDocker", noremap = true, silent = true }),
  },

  -- buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        -- separator_style = "slant",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
      highlights = nil,
    },
  },

  -- -- filename
  -- {
  --   "b0o/incline.nvim",
  --   dependencies = { "craftzdog/solarized-osaka.nvim" },
  --   event = "BufReadPre",
  --   priority = 1200,
  --   config = function()
  --     local colors = require("solarized-osaka.colors").setup()
  --     require("incline").setup({
  --       highlight = {
  --         groups = {
  --           InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
  --           InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
  --         },
  --       },
  --       window = { margin = { vertical = 0, horizontal = 1 } },
  --       hide = {
  --         cursorline = true,
  --       },
  --       render = function(props)
  --         local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
  --         if vim.bo[props.buf].modified then
  --           filename = "[+] " .. filename
  --         end
  --
  --         local icon, color = require("nvim-web-devicons").get_icon_color(filename)
  --         return { { icon, guifg = color }, { " " }, { filename } }
  --       end,
  --     })
  --   end,
  -- },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      plugins = {
        gitsigns = true,
        tmux = true,
        kitty = { enabled = false, font = "+2" },
      },
    },
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },
  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    lazy = true,
    opts = {
      startVisible = true,
      showBlankVirtLine = true,
      highlightColor = { link = "Comment" },
      hints = {
        Caret = { text = "^", prio = 2 },
        Dollar = { text = "$", prio = 1 },
        MatchingPair = { text = "%", prio = 5 },
        Zero = { text = "0", prio = 1 },
        w = { text = "w", prio = 10 },
        b = { text = "b", prio = 9 },
        e = { text = "e", prio = 8 },
        W = { text = "W", prio = 7 },
        B = { text = "B", prio = 6 },
        E = { text = "E", prio = 5 },
      },
      gutterHints = {
        G = { text = "G", prio = 10 },
        gg = { text = "gg", prio = 9 },
        PrevParagraph = { text = "{", prio = 8 },
        NextParagraph = { text = "}", prio = 8 },
      },
      disabled_fts = {
        "startify",
      },
    },
  },
  {
    "m4xshen/hardtime.nvim",
    enabled = true,
    dependencies = { "MunifTanjim/nui.nvim" },
    -- Was told to use this event by m4xshen himself, in discord
    -- https://discord.com/channels/1323810827220029441/1371572869838012487/1371660878344097832
    event = "BufEnter",
    keys = {
      -- { "j", "v:count == 0 ? 'gj' : 'j'", mode = { "n", "x" }, expr = true, silent = true, desc = "Down" },
      -- { "k", "v:count == 0 ? 'gk' : 'k'", mode = { "n", "x" }, expr = true, silent = true, desc = "Up" },
    },
    opts = function(_, opts)
      -- make sure the default table exists
      opts.restricted_keys = opts.restricted_keys or {}
      -- do NOT restrict gj / gk
      opts.restricted_keys["gj"] = false
      opts.restricted_keys["gk"] = false
    end,
    -- マウスと矢印キーがキーボードのホーム キー列にない場合は、使用しないでください。
    -- 5j 12-画面内での垂直方向の移動には相対ジャンプ (例: ) を使用します。
    -- CTRL-U CTRL-D CTRL-B CTRL-F gg G画面外での垂直移動に使用します。
    -- w W b B e E ge gE短距離の水平移動にはワードモーション（ ）を使用します。
    -- f F t T , ; 0 ^ $中距離から長距離の水平移動に使用します。
    -- ci{ y5j dap可能な限り、演算子 + モーション/テキスト オブジェクト (例: ) を使用します。
    -- 括弧間を移動するには、%および 角括弧コマンド ( を参照)を使用します。:h [
    -- "m4xshen/hardtime.nvim",
    -- dependencies = { "MunifTanjim/nui.nvim" },
    -- -- config = function()
    -- opts = {
    --   disable_filetypes = {
    --     lazy = false, -- enable hardtime in lazy FileType
    --     ["dapui*"] = false,
    --     ["qf"] = true,
    --     ["netrw"] = true,
    --     ["NvimTree"] = true,
    --     ["md"] = true,
    --     ["markdown"] = true,
    --     ["mason"] = true,
    --     ["oil"] = true,
    --   },
    -- },
    -- hints = {
    --   ["k%^"] = {
    --     message = function()
    --       return "Use - instead of k^" -- return the hint message you want to display
    --     end,
    --     length = 2, -- the length of actual key strokes that matches this pattern
    --   },
    --   ["d[tTfF].i"] = { -- this matches d + {t/T/f/F} + {any character} + i
    --     message = function(keys) -- keys is a string of key strokes that matches the pattern
    --       return "Use " .. "c" .. keys:sub(2, 3) .. " instead of " .. keys
    --       -- example: Use ct( instead of dt(i
    --     end,
    --     length = 4,
    --   },
    -- },
  },
  {
    "nvzone/showkeys",
    cmd = "ShowkeysToggle",
    opts = {
      -- top-right, top-center, top-left, bottom-right,bottom-center, bottom-left
      position = "bottom-right",
      maxkeys = 3,
      show_count = true,
      keyformat = {

        ["<BS>"] = "󰁮 ",
        ["<CR>"] = "⏎",
        ["<Space>"] = "󱁐",
        ["<Up>"] = "󰁝",
        ["<Down>"] = "󰁅",
        ["<Left>"] = "󰁍",
        ["<Right>"] = "󰁔",
        ["<PageUp>"] = "Page 󰁝",
        ["<PageDown>"] = "Page 󰁅",
        ["<D>"] = "⌘",
        ["<C>"] = "⌃",
        ["<A>"] = "⌥",
        ["<S>"] = "⇧",
        ["<M>"] = "⌥",
        ["<Tab>"] = "⇥",
        ["<S-Tab>"] = "⇤",
        ["<S-Right>"] = "⇒",
        ["<S-Left>"] = "⇐",
        ["<S-Up>"] = "⇑",
        ["<S-Down>"] = "⇓",
        ["<C-Right>"] = "⇒",
        ["<C-Left>"] = "⇐",
        ["<C-Up>"] = "⇑",
        ["<C-Down>"] = "⇓",
        ["<Return>"] = "⏎",
        ["<ESC>"] = "⎋",
      },
    },
    keys = {
      { "<leader>ks", "<cmd>ShowkeysToggle<cr>", desc = "Showkeys Toggle" },
    },
  },
  -- {
  --   "tribela/transparent.nvim",
  --   event = "VimEnter",
  --   -- config = true,
  --   config = function()
  --     require("transparent").setup({
  --       enable = true,
  --       extra_groups = { -- table/string: additional groups that should be cleared
  --         "BufferLine",
  --         "BufferLineTabClose",
  --         "BufferlineBufferSelected",
  --         "BufferLineFill",
  --         "BufferLineBackground",
  --         "BufferLineSeparator",
  --         "BufferLineIndicatorSelected",
  --         "IndentBlanklineChar",
  --         -- make floating windows transparent
  --         "LspFloatWinNormal",
  --         "Normal",
  --         "NormalFloat",
  --         "FloatBorder",
  --         "TelescopeNormal",
  --         "TelescopeBorder",
  --         "TelescopePromptBorder",
  --         "SagaBorder",
  --         "SagaNormal",
  --         "lualine",
  --       },
  --       exclude = {}, -- table: groups you don't want to clear
  --       -- clear_prefix = { "lualine", "NeoTree", "BufferLine" },
  --     })
  --   end,
  -- },
}
