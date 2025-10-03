return {
  -- tools
  {
    "mason-org/mason.nvim",
    { "mason-org/mason.nvim", version = "^1.0.0" },
    { "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",
        "shfmt",
        "tailwindcss-language-server",
        "typescript-language-server",
        -- "docker-compose-language-service",
        -- "dockerfile-language-server",
        -- "prisma-language-server",
        "css-lsp",
        -- "emmet-ls",
        -- "html-lsp",
        -- "htmx-ls",
        -- "templ",
        "lua-language-server",
        "svelte-language-server",
        "harper-ls",
        "ruff",
        -- "python-lsp-server",
        -- "jedi-language-server",
        -- "black",
        -- "isort",
        -- "flake8",
        -- "mypy",
        -- "pylint",
      })
    end,
  },

  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
    },
    opts = {
      inlay_hints = { enabled = false },
      ---@type lspconfig.options
      servers = {
        -- pylsp = {
        --   settings = {
        --     pylsp = {
        --       pyflakes = { enabled = false },
        --       pycodestyle = { enabled = false },
        --       autopep8 = { enabled = false },
        --       yapf = { enabled = false },
        --       mccabe = { enabled = false },
        --       pylsp_mypy = { enabled = false },
        --       pylsp_black = { enabled = false },
        --       pylsp_isort = { enabled = false },
        --     },
        --   },
        -- },
        harper_ls = {
          enabled = true,
          filetypes = { "markdown" },
          settings = {
            ["harper-ls"] = {
              userDictPath = "~/.config/LazyVim/spell/en.utf-8.add",
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
        ruff = {
          init_options = {
            settings = {
              python = {
                inlayHints = true,
              },
              -- Ruff language server settings go here
            },
          },
          -- Notes on code actions: https://github.com/astral-sh/ruff-lsp/issues/119#issuecomment-1595628355
          -- Get isort like behavior: https://github.com/astral-sh/ruff/issues/8926#issuecomment-1834048218
          commands = {
            RuffAutofix = {
              function()
                vim.lsp.buf.execute_command({
                  command = "ruff.applyAutofix",
                  arguments = {
                    { uri = vim.uri_from_bufnr(0) },
                  },
                })
              end,
              description = "Ruff: Fix all auto-fixable problems",
            },
            RuffOrganizeImports = {
              function()
                vim.lsp.buf.execute_command({
                  command = "ruff.applyOrganizeImports",
                  arguments = {
                    { uri = vim.uri_from_bufnr(0) },
                  },
                })
              end,
              description = "Ruff: Format imports",
            },
          },
        },
        -- ruff_lsp = {},
        -- pyright = {
        --   settings = {
        --     pyright = {
        --       -- Using Ruff's import organizer
        --       disableOrganizeImports = true,
        --     },
        --     python = {
        --       analysis = {
        --         -- Ignore all files for analysis to exclusivery use Ruff for
        --         -- linting
        --         ignore = { "*" },
        --       },
        --     },
        --   },
        -- },
        -- svelte = {},
        -- dockerls = {},
        -- docker_compose_language_service = {},
        -- html = {},
        -- jedi_language_server = {},
        -- jsonls = {},
        -- prismals = {},
        cssls = {},
        -- emmet_ls = {},
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
        vtsls = {
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
          },
        },
        svelte = {
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
          },
        },
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
      -- vim.list_extend(Keys, {
      --   { "gd", "<cmd>FzfLua lsp_definitions     jump1=true ignore_current_line=true<cr>", desc = "Goto Definition", has = "definition" },
      --   { "gr", "<cmd>FzfLua lsp_references      jump1=true ignore_current_line=true<cr>", desc = "References", nowait = true },
      --   { "gI", "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>", desc = "Goto Implementation" },
      --   { "gy", "<cmd>FzfLua lsp_typedefs        jump1=true ignore_current_line=true<cr>", desc = "Goto T[y]pe Definition" },
      -- })

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
        {
          "gr",
          function()
            -- DO NOT RESUSE WINDOW
            require("telescope.builtin").lsp_references({ reuse_win = false })
          end,
          desc = "References",
          nowait = true,
        },
        {
          "gI",
          function()
            -- DO NOT RESUSE WINDOW
            require("telescope.builtin").lsp_implementations({ reuse_win = false })
          end,
          desc = "Goto Implementation",
        },
        {
          "gy",
          function()
            -- DO NOT RESUSE WINDOW
            require("telescope.builtin").lsp_typedefs({ reuse_win = false })
          end,
          desc = "Goto T[y]pe Definition",
        },
      })
    end,
    -- require("lspconfig").ruff.setup({
    --   init_options = {
    --     settings = {
    --       -- Ruff language servier settings go here
    --     },
    --   },
    -- }),
  },
}
