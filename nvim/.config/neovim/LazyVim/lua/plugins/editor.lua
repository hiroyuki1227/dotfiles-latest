return {
  {
    enabled = false,
    "folke/flash.nvim",
    ---@type Flash.Config
    opts = {
      search = {
        forward = true,
        multi_window = false,
        wrap = false,
        incremental = true,
      },
    },
  },

  {
    "nvim-mini/mini.hipatterns",
    event = "BufReadPre",
    opts = {
      highlighters = {
        hsl_color = {
          pattern = "hsl%(%d+,? %d+%%?,? %d+%%?%)",
          group = function(_, match)
            local utils = require("solarized-osaka.hsl")
            --- @type string, string, string
            local nh, ns, nl = match:match("hsl%((%d+),? (%d+)%%?,? (%d+)%%?%)")
            --- @type number?, number?, number?
            local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)
            --- @type string
            local hex_color = utils.hslToHex(h, s, l)
            return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
          end,
        },
      },
    },
  },
  {
    "dinhhuy258/git.nvim",
    event = "BufReadPre",
    opts = {
      keymaps = {
        -- Open blame window
        blame = "<Leader>gb",
        -- Open file/folder in git repository
        browse = "<Leader>go",
      },
    },
  },
  -- {
  -- 	"nvim-telescope/telescope.nvim",
  -- 	dependencies = {
  -- 		{
  -- 			"nvim-telescope/telescope-fzf-native.nvim",
  -- 			build = "make",
  -- 		},
  -- 		"nvim-telescope/telescope-file-browser.nvim",
  -- 	},
  -- 	keys = {
  -- 		{
  -- 			"<leader>fP",
  -- 			function()
  -- 				require("telescope.builtin").find_files({
  -- 					cwd = require("lazy.core.config").options.root,
  -- 				})
  -- 			end,
  -- 			desc = "Find Plugin File",
  -- 		},
  -- 		{
  -- 			";f",
  -- 			function()
  -- 				local builtin = require("telescope.builtin")
  -- 				builtin.find_files({
  -- 					no_ignore = false,
  -- 					hidden = true,
  -- 				})
  -- 			end,
  -- 			desc = "Lists files in your current working directory, respects .gitignore",
  -- 		},
  -- 		{
  -- 			";r",
  -- 			function()
  -- 				local builtin = require("telescope.builtin")
  -- 				builtin.live_grep({
  -- 					additional_args = { "--hidden" },
  -- 				})
  -- 			end,
  -- 			desc = "Search for a string in your current working directory and get results live as you type, respects .gitignore",
  -- 		},
  -- 		{
  -- 			"\\\\",
  -- 			function()
  -- 				local builtin = require("telescope.builtin")
  -- 				builtin.buffers()
  -- 			end,
  -- 			desc = "Lists open buffers",
  -- 		},
  -- 		{
  -- 			";t",
  -- 			function()
  -- 				local builtin = require("telescope.builtin")
  -- 				builtin.help_tags()
  -- 			end,
  -- 			desc = "Lists available help tags and opens a new window with the relevant help info on <cr>",
  -- 		},
  -- 		{
  -- 			";;",
  -- 			function()
  -- 				local builtin = require("telescope.builtin")
  -- 				builtin.resume()
  -- 			end,
  -- 			desc = "Resume the previous telescope picker",
  -- 		},
  -- 		{
  -- 			";e",
  -- 			function()
  -- 				local builtin = require("telescope.builtin")
  -- 				builtin.diagnostics()
  -- 			end,
  -- 			desc = "Lists Diagnostics for all open buffers or a specific buffer",
  -- 		},
  -- 		{
  -- 			";s",
  -- 			function()
  -- 				local builtin = require("telescope.builtin")
  -- 				builtin.treesitter()
  -- 			end,
  -- 			desc = "Lists Function names, variables, from Treesitter",
  -- 		},
  -- 		{
  -- 			"sf",
  -- 			function()
  -- 				local telescope = require("telescope")
  --
  -- 				local function telescope_buffer_dir()
  -- 					return vim.fn.expand("%:p:h")
  -- 				end
  --
  -- 				telescope.extensions.file_browser.file_browser({
  -- 					path = "%:p:h",
  -- 					cwd = telescope_buffer_dir(),
  -- 					respect_gitignore = false,
  -- 					hidden = true,
  -- 					grouped = true,
  -- 					previewer = false,
  -- 					initial_mode = "normal",
  -- 					layout_config = { height = 40 },
  -- 				})
  -- 			end,
  -- 			desc = "Open File Browser with the path of the current buffer",
  -- 		},
  -- 	},
  -- 	config = function(_, opts)
  -- 		local telescope = require("telescope")
  -- 		local actions = require("telescope.actions")
  -- 		local fb_actions = require("telescope").extensions.file_browser.actions
  --
  -- 		opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
  -- 			wrap_results = true,
  -- 			layout_strategy = "horizontal",
  -- 			layout_config = { prompt_position = "top" },
  -- 			sorting_strategy = "ascending",
  -- 			winblend = 0,
  -- 			mappings = {
  -- 				n = {},
  -- 			},
  -- 		})
  -- 		opts.pickers = {
  -- 			diagnostics = {
  -- 				theme = "ivy",
  -- 				initial_mode = "normal",
  -- 				layout_config = {
  -- 					preview_cutoff = 9999,
  -- 				},
  -- 			},
  -- 		}
  -- 		opts.extensions = {
  -- 			file_browser = {
  -- 				theme = "dropdown",
  -- 				-- disables netrw and use telescope-file-browser in its place
  -- 				hijack_netrw = true,
  -- 				mappings = {
  -- 					-- your custom insert mode mappings
  -- 					["n"] = {
  -- 						-- your custom normal mode mappings
  -- 						["N"] = fb_actions.create,
  -- 						["h"] = fb_actions.goto_parent_dir,
  -- 						["/"] = function()
  -- 							vim.cmd("startinsert")
  -- 						end,
  -- 						["<C-u>"] = function(prompt_bufnr)
  -- 							for i = 1, 10 do
  -- 								actions.move_selection_previous(prompt_bufnr)
  -- 							end
  -- 						end,
  -- 						["<C-d>"] = function(prompt_bufnr)
  -- 							for i = 1, 10 do
  -- 								actions.move_selection_next(prompt_bufnr)
  -- 							end
  -- 						end,
  -- 						["<PageUp>"] = actions.preview_scrolling_up,
  -- 						["<PageDown>"] = actions.preview_scrolling_down,
  -- 					},
  -- 				},
  -- 			},
  -- 		}
  -- 		telescope.setup(opts)
  -- 		require("telescope").load_extension("fzf")
  -- 		require("telescope").load_extension("file_browser")
  -- 	end,
  -- },
  --

  {
    "kazhala/close-buffers.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>th",
        function()
          require("close_buffers").delete({ type = "hidden" })
        end,
        "Close Hidden Buffers",
      },
      {
        "<leader>tu",
        function()
          require("close_buffers").delete({ type = "nameless" })
        end,
        "Close Nameless Buffers",
      },
    },
  },

  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>co", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    opts = {
      -- add your options that should be passed to the setup() function here
      position = "right",
    },
  },
  -- {
  --   "mfussenegger/nvim-lint",
  --   optional = true,
  --   config = function()
  --     local lint = require("lint")
  --
  --     lint.linters_by_ft = {
  --       javascript = { "eslint_d" },
  --       typescript = { "eslint_d" },
  --       javascriptreact = { "eslint_d" },
  --       typescriptreact = { "eslint_d" },
  --       svelte = { "eslint_d" },
  --       kotlin = { "ktlint" },
  --       terraform = { "tflint" },
  --     }
  --
  --     local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
  --
  --     vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  --       group = lint_augroup,
  --       callback = function()
  --         lint.try_lint()
  --       end,
  --     })
  --
  --     vim.keymap.set("n", "<leader>ll", function()
  --       lint.try_lint()
  --     end, { desc = "Trigger linting for current file" })
  --   end,
  --   opts = {
  --     linters = {
  --       -- https://github.com/LazyVim/LazyVim/discussions/4094#discussioncomment-10178217
  --       ["markdownlint-cli2"] = {
  --         args = { "--config", os.getenv("HOME") .. "~/dotfiles/.markdownlint.yaml", "--" },
  --       },
  --     },
  --   },
  -- },
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   cmd = "Neotree",
  --   keys = {
  --     {
  --       "<leader>fe",
  --       function()
  --         require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
  --       end,
  --       desc = "Explorer NeoTree (Root Dir)",
  --     },
  --     {
  --       "<leader>fE",
  --       function()
  --         require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
  --       end,
  --       desc = "Explorer NeoTree (cwd)",
  --     },
  --     { "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
  --     { "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
  --     {
  --       "<leader>ge",
  --       function()
  --         require("neo-tree.command").execute({ source = "git_status", toggle = true })
  --       end,
  --       desc = "Git Explorer",
  --     },
  --     {
  --       "<leader>be",
  --       function()
  --         require("neo-tree.command").execute({ source = "buffers", toggle = true })
  --       end,
  --       desc = "Buffer Explorer",
  --     },
  --   },
  --   deactivate = function()
  --     vim.cmd([[Neotree close]])
  --   end,
  --   init = function()
  --     -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
  --     -- because `cwd` is not set up properly.
  --     vim.api.nvim_create_autocmd("BufEnter", {
  --       group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
  --       desc = "Start Neo-tree with directory",
  --       once = true,
  --       callback = function()
  --         if package.loaded["neo-tree"] then
  --           return
  --         else
  --           local stats = vim.uv.fs_stat(vim.fn.argv(0))
  --           if stats and stats.type == "directory" then
  --             require("neo-tree")
  --           end
  --         end
  --       end,
  --     })
  --   end,
  --   opts = {
  --     sources = { "filesystem", "buffers", "git_status" },
  --     open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
  --     filesystem = {
  --       bind_to_cwd = false,
  --       follow_current_file = { enabled = true },
  --       use_libuv_file_watcher = true,
  --       filtered_items = {
  --         visivle = false,
  --         show_hidden_count = true,
  --         hide_dotfiles = false,
  --         hide_gitignored = false,
  --         hide_by_name = {
  --           "node_modules",
  --           "thumbs.db",
  --         },
  --         never_show = {
  --           ".git",
  --           ".DS_Store",
  --           ".history",
  --         },
  --       },
  --     },
  --     window = {
  --       mappings = {
  --         ["l"] = "open",
  --         ["h"] = "close_node",
  --         ["<space>"] = "none",
  --         ["Y"] = {
  --           function(state)
  --             local node = state.tree:get_node()
  --             local path = node:get_id()
  --             vim.fn.setreg("+", path, "c")
  --           end,
  --           desc = "Copy Path to Clipboard",
  --         },
  --         ["O"] = {
  --           function(state)
  --             require("lazy.util").open(state.tree:get_node().path, { system = true })
  --           end,
  --           desc = "Open with System Application",
  --         },
  --         ["P"] = { "toggle_preview", config = { use_float = false } },
  --       },
  --     },
  --     default_component_configs = {
  --       indent = {
  --         with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
  --         expander_collapsed = "",
  --         expander_expanded = "",
  --         expander_highlight = "NeoTreeExpander",
  --       },
  --       git_status = {
  --         symbols = {
  --           unstaged = "󰄱",
  --           staged = "󰱒",
  --         },
  --       },
  --     },
  --   },
  --   config = function(_, opts)
  --     local function on_move(data)
  --       Snacks.rename.on_rename_file(data.source, data.destination)
  --     end
  --
  --     local events = require("neo-tree.events")
  --     opts.event_handlers = opts.event_handlers or {}
  --     vim.list_extend(opts.event_handlers, {
  --       { event = events.FILE_MOVED, handler = on_move },
  --       { event = events.FILE_RENAMED, handler = on_move },
  --     })
  --     require("neo-tree").setup(opts)
  --     vim.api.nvim_create_autocmd("TermClose", {
  --       pattern = "*lazygit",
  --       callback = function()
  --         if package.loaded["neo-tree.sources.git_status"] then
  --           require("neo-tree.sources.git_status").refresh()
  --         end
  --       end,
  --     })
  --   end,
  -- },
}
