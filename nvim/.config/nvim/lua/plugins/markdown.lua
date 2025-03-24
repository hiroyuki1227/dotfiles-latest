return {
  {
    "OXY2DEV/markview.nvim",
    lazy = false, -- Recommended
    branch = "dev",
    -- ft = "markdown" -- If you decide to lazy-load anyway

    dependencies = {
      -- You will not need this if you installed the
      -- parsers manually
      -- Or if the parsers are in your $RUNTIMEPATH
      "nvim-treesitter/nvim-treesitter",

      "nvim-tree/nvim-web-devicons",
    },
    -- config = function()
    --     vim.cmd([[highlight MarkviewHeading1 guibg=#E67E80 guifg=white]])
    --     vim.cmd([[highlight MarkviewHeading2 guibg=#EB9C5F guifg=white]])
    --     vim.cmd([[highlight MarkviewHeading3 guibg=#83C092 guifg=white]])
    --     vim.cmd([[highlight MarkviewHeading4 guibg=#7FBBB3 guifg=white]])
    --     vim.cmd([[highlight MarkviewHeading5 guibg=#D3C6AA guifg=white]])
    --     vim.cmd([[highlight MarkviewHeading6 guibg=#384B55 guifg=white]])
    --     vim.cmd([[highlight MarkviewCode guibg=#1e2326]])
    -- end,
  },
  {
    -- Install markdown preview, use npx if available.
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function(plugin)
      if vim.fn.executable("npx") then
        vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
      else
        vim.cmd([[Lazy load markdown-preview.nvim]])
        vim.fn["mkdp#util#install"]()
      end
    end,
    init = function()
      if vim.fn.executable("npx") then
        vim.g.mkdp_filetypes = { "markdown" }
      end
    end,
    keys = {
      { "<leader>msp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview Toggle" },
      { "<leader>mss", "<cmd>MarkdownPreview<cr>", desc = "Markdown Preview" },
      { "<leader>msx", "<cmd>MarkdownPreviewStop<cr>", desc = "Markdown Preview Stop" },
    },
  },
}
