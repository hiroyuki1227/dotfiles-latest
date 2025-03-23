return {
	-- Incremental rename
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		config = true,
	},

	-- Go forward/backward with square brackets
	{
		"echasnovski/mini.bracketed",
		event = "BufReadPost",
		config = function()
			local bracketed = require("mini.bracketed")
			bracketed.setup({
				file = { suffix = "" },
				window = { suffix = "" },
				quickfix = { suffix = "" },
				yank = { suffix = "" },
				treesitter = { suffix = "n" },
			})
		end,
	},

	-- Better increase/descrease
	{
		"monaqa/dial.nvim",
    -- stylua: ignore
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
		config = function()
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				default = {
					augend.integer.alias.decimal,
					augend.integer.alias.hex,
					augend.date.alias["%Y/%m/%d"],
					augend.constant.alias.bool,
					augend.semver.alias.semver,
					augend.constant.new({ elements = { "let", "const" } }),
				},
			})
		end,
	},
	-- {
	-- 	"L3MON4D3/LuaSnip",
	-- 	lazy = true,
	-- 	build = (not LazyVim.is_win())
	-- 			and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
	-- 		or nil,
	-- 	dependencies = {
	-- 		{
	-- 			"rafamadriz/friendly-snippets",
	-- 			config = function()
	-- 				require("luasnip.loaders.from_vscode").lazy_load()
	-- 				require("luasnip.loaders.from_vscode").lazy_load({
	-- 					paths = { vim.fn.stdpath("config") .. "/snippets" },
	-- 				})
	-- 			end,
	-- 		},
	-- 	},
	-- 	opts = {
	-- 		history = true,
	-- 		delete_check_events = "TextChanged",
	-- 	},
	-- },
}
