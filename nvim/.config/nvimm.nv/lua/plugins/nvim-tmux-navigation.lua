return {
  {
    "alexghergh/nvim-tmux-navigation",
    keys = {
      { "<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", mode = { "n", "i", "v" }, desc = "TmuxNavigateLeft" },
      { "<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", mode = { "n", "i", "v" }, desc = "TmuxNavigateDown" },
      { "<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", mode = { "n", "i", "v" }, desc = "TmuxNavigateUp" },
      { "<C-l>", "<cmd>NvimTmuxNavigateRigh<tcr>", mode = { "n", "i", "v" }, desc = "TmuxNavigateRight" },
      { "<C-\\>", "<cmd>NvimTmuxNavigatePrevious<cr>", mode = { "n", "i", "v" }, desc = "TmuxNavigatePrevious" },
    },
  },
}
-- config = function()
--   require("nvim-tmux-navigation").setup({})
--   vim.keymap.set("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", {})
--   vim.keymap.set("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", {})
--   vim.keymap.set("n", "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", {})
--   vim.keymap.set("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", {})
--   vim.keymap.set("n", "<C-\\>", "<Cmd>NvimTmuxNavigatePrevious<CR>", {})
-- end
