require("config.keymaps-add")

-- local discipline = require("discipline")
-- discipline.cowboy()

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Do things without affecting the registers
map("n", "x", '"_x')
map("n", "<Leader>p", '"0p')
map("n", "<Leader>P", '"0P')
map("v", "<Leader>p", '"0p')
map("n", "<Leader>c", '"_c')
map("n", "<Leader>C", '"_C')
map("v", "<Leader>c", '"_c')
map("v", "<Leader>C", '"_C')
map("n", "<Leader>d", '"_d')
map("n", "<Leader>D", '"_D')
map("v", "<Leader>d", '"_d')
map("v", "<Leader>D", '"_D')

-- increment/decrement numbers
map("n", "+", "<C-a>", { desc = "Increment number" }) -- increment
map("n", "-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- Delete a word backwards
map("n", "dw", 'vb"_d')

-- Select all
map("n", "<C-a>", "gg<S-v>G")

-- Disable continuations
map("n", "<Leader>o", "o<Esc>^Da", opts)
map("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplisf
map("n", "<C-m>", "<C-i>", opts)

-- save file without auto-formatting
-- map("n", "<leader>sn", "<cmd>noautocmd w<CR>", { desc = "Save without formatting" })
--

-- map("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
map("n", "<Esc>", ":noh<CR>", { desc = "clear search highlight" })

-- window management
map("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
map("n", "<leader>ws", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
map("n", "<leader>w=", "<C-w>=", { desc = "Make splits equal size(Equal High and Wide)" }) -- make split windows equal width & height
map("n", "<leader>wd", "<cmd>close<CR>", { desc = "Delete Current Window" }) -- close current split window

-- tab management
map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
map("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
map("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
map("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- buffer management
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" }) -- delete buffer
map("n", "<leader>bD", "<cmd>%bdelete<CR>", { desc = "Delete all buffers" }) -- delete all buffers
map("n", "<leader>ba", "<cmd>%bd<CR>", { desc = "Delete all buffers except current" }) -- delete all buffers except current
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Go to next buffer" }) -- go to next buffer
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Go to previous buffer" }) -- go to previous buffer
map("n", "<Tab>", ":bnext<CR>", opts)
map("n", "<S-Tab>", ":bprevious<CR>", opts)
--
-- Move Window
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Resize with arrows
map("n", "<C-w><up>", "<C-w>+", { desc = "Resize window up" })
map("n", "<C-w><Down>", "<C-w>-", { desc = "Resize window down" })
map("n", "<C-w><Left>", "<C-w><", { desc = "Resize window left" })
map("n", "<C-w><Right>", "<C-w>>", { desc = "Resize window right" })

-- -- Diagnostics
-- map("n", "<C-j>", function()
--   vim.diagnostic.goto_next()
-- end, opts)
--
-- require("user.hsl").replaceHexWithHSL()
--
map("n", "<leader>r", function() end)
require("user.lsp").toggleInlayHints()

-- map("n", "<leader>i", function() end)
--
vim.api.nvim_create_user_command("ToggleAutoformat", function()
  require("user.lsp").toggleAutoformat()
end, {})
