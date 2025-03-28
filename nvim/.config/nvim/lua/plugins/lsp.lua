return {
  -- tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",
        "shfmt",
        "tailwindcss-language-server",
        "typescript-language-server",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "prisma-language-server",
        "css-lsp",
        "emmet-ls",
        "html-lsp",
        -- "htmx-ls",
        -- "templ",
        "lua-language-server",
        "svelte-language-server",
        "harper-ls",
      })
    end,
  },

  -- lsp servers
  {
    "neovim/nvim-lspconfig",

    opts = {
      inlay_hints = { enabled = false },
      ---@type lspconfig.options
      servers = {
        svelte = {},
        dockerls = {},
        prismals = {},
        cssls = {},
        emmet_ls = {},
        tailwindcss = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
        },
        tsserver = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
          single_file_support = false,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
        html = {},
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
        lua_ls = {
          -- enabled = false,
          single_file_support = true,
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                workspaceWord = true,
                callSnippet = "Both",
              },
              misc = {
                parameters = {
                  -- "--log-level=trace",
                },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
              doc = {
                privateName = { "^_" },
              },
              type = {
                castNumberToInteger = true,
              },
              diagnostics = {
                disable = { "incomplete-signature-doc", "trailing-space" },
                -- enable = false,
                groupSeverity = {
                  strong = "Warning",
                  strict = "Warning",
                },
                groupFileStatus = {
                  ["ambiguity"] = "Opened",
                  ["await"] = "Opened",
                  ["codestyle"] = "None",
                  ["duplicate"] = "Opened",
                  ["global"] = "Opened",
                  ["luadoc"] = "Opened",
                  ["redefined"] = "Opened",
                  ["strict"] = "Opened",
                  ["strong"] = "Opened",
                  ["type-check"] = "Opened",
                  ["unbalanced"] = "Opened",
                  ["unused"] = "Opened",
                },
                unusedLocalExclude = { "_*" },
              },
              format = {
                enable = false,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
            },
          },
        },
      },
      setup = {
        capabilities = require("blink.cmp").get_lsp_capabilities({
          textDocument = { completion = { completionItem = { snippetSupport = false } } },
        }),
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      vim.list_extend(keys, {
        {
          "gd",
          function()
            -- DO NOT RESUSE WINDOW
            require("telescope.builtin").lsp_definitions({ reuse_win = false })
          end,
          desc = "Goto Definition",
          has = "definition",
        },
      })
    end,
  },
  -- ~/github/dotfiles-latest/neovim/neobean/lua/plugins/nvim-lspconfig.lua
  -- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/plugins/nvim-lspconfig.lua
  --
  -- https://github.com/neovim/nvim-lspconfig

  {
    "neovim/nvim-lspconfig",
    opts = {

      -- This disables inlay hints
      -- When programming in Go, these made my experience feel like shit, because were
      -- very intrusive and I never got used to them.
      --
      -- Folke has a keymap to toggle inaly hints with <leader>uh
      inlay_hints = { enabled = false },

      servers = {
        -- https://www.reddit.com/r/neovim/comments/1j7ookn/comment/mgysste/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
        -- The hover window configuration for the diagnostics is done in lamw26wmal
        -- ~/github/dotfiles-latest/neovim/neobean/lua/config/autocmds.lua
        harper_ls = {
          enabled = true,
          filetypes = { "markdown" },
          settings = {
            ["harper-ls"] = {
              userDictPath = "~/.config/nvim/spell/en.utf-8.add",
              linters = {
                ToDoHyphen = false,
                -- SentenceCapitalization = true,
                -- SpellCheck = true,
              },
              isolateEnglish = false,
              markdown = {
                -- [ignores this part]()
                -- [[ also ignores my marksman links ]]
                IgnoreLinkTitle = true,
              },
            },
          },
        },
      },
    },
  },
}
