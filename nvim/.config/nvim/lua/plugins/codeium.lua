return {
	"monkoose/neocodeium",
	event = "VeryLazy",
	config = function()
		require("neocodeium").setup()
		-- vim.keymap.set("i", "<Tab>", function()
		-- 	require("neocodeium").accept()
		-- end)

		vim.keymap.set("i", "<C-g>", function()
			require("neocodeium").accept()
		end, { desc = "[P]Codeium Accept" })

		vim.keymap.set("i", "<C-w>", function()
			require("neocodeium").accept_word()
		end, { desc = "[P]Codeium Accept Word" })
		vim.keymap.set("i", "<C-a>", function()
			require("neocodeium").accept_line()
		end, { desc = "[P]Codeium Accept Line" })
		vim.keymap.set("i", "<C-j>", function()
			require("neocodeium").cycle_or_complete(1)
		end, { desc = "[P]Codeium Cycle Plus" })
		vim.keymap.set("i", "<C-k>", function()
			require("neocodeium").cycle_or_complete(-1)
		end, { desc = "[P]Codeium Cycle Minus" })
		vim.keymap.set("i", "<C-x>", function()
			require("neocodeium").clear()
		end, { desc = "[P]Codeium Clear" })
	end,
}
