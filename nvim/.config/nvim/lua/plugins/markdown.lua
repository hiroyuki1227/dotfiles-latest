return {
  {
    -- Install markdown preview, use npx if available.
    "iamcco/markdown-preview.nvim",
    -- cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    -- ft = { "markdown" },
    -- build = function(plugin)
    --   if vim.fn.executable("yarn") then
    --     -- vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
    --     vim.cmd("!cd " .. plugin.dir .. " && cd app && yarn install")
    --   else
    --     vim.cmd([[Lazy load markdown-preview.nvim]])
    --     vim.fn["mkdp#util#install"]()
    --   end
    -- end,
    -- init = function()
    --   if vim.fn.executable("yarn") then
    --     vim.g.mkdp_filetypes = { "markdown" }
    --   end
    -- end,
    keys = {
      { "<leader>msp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview Toggle" },
      { "<leader>mss", "<cmd>MarkdownPreview<cr>", desc = "Markdown Preview" },
      { "<leader>msx", "<cmd>MarkdownPreviewStop<cr>", desc = "Markdown Preview Stop" },
    },
    init = function()
      vim.g.mkdp_page_tile = "${name}"
    end,
  },
}
