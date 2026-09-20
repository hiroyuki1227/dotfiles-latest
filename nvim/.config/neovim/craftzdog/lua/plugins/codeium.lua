return {
  -- {
  --   "Exafunction/windsurf.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "saghen/blink.cmp",
  --     -- "hrsh7th/nvim-cmp",
  --   },
  --   config = function()
  --     require("codeium").setup()
  --   end,
  -- },
  -- {
  --   "saghen/blink.cmp",
  --   dependencies = {
  --     {
  --       "Exafunction/codeium.nvim",
  --     },
  --   },
  --   opts = {
  --     sources = {
  --       default = { "lsp", "path", "snippets", "buffer", "codeium" },
  --       providers = {
  --         codeium = { name = "Codeium", module = "codeium.blink", async = true },
  --       },
  --     },
  --   },
  -- },
  {
    "monkoose/neocodeium",
    event = "VeryLazy",
    config = function()
      require("neocodeium").setup()
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

      vim.g.codeium_filetype = {
        yaml = false,
        markdown = false,
      }
    end,
  },
}
