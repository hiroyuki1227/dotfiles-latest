-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
-- local null_ls = require("null-ls")
--
-- local opts = {
--   sources = {
--     null_ls.builtins.formatting.prettierd,
--   },
--   on_attach = function(client, bufnr)
--     if client.supports_method("textDocument/formatting") then
--       vim.api.nvim_clear_autocmds({
--         group = augroup,
--         buffer = bufnr,
--       })
--       vim.api.nvim_create_autocmd("BufWritePre", {
--         group = augroup,
--         buffer = bufnr,
--         callback = function()
--           vim.lsp.buf.format({ bufnr = bufnr })
--         end,
--       })
--     end
--   end,
-- }
--
-- return opts

-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
-- local null_ls = require("null-ls")
--
-- local opts = {
--   sources = {
--     -- フォーマッティング用
--     null_ls.builtins.formatting.prettierd,
--   },
--
--   on_attach = function(client, bufnr)
--     if client.supports_method("textDocument/formatting") then
--       local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
--       vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
--       vim.api.nvim_create_autocmd("BufWritePre", {
--         group = augroup,
--         buffer = bufnr,
--         callback = function()
--           vim.lsp.buf.format({ bufnr = bufnr })
--         end,
--       })
--     end
--   end,
-- }
--
-- return opts
--

return {
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.diagnostics.golangci_lint,
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.rstcheck,
        null_ls.builtins.diagnostics.markdownlint.with({
          args = { "--stdin", "-c", vim.fn.expand("$HOME/.markdownlintrc") },
        }),
        null_ls.builtins.diagnostics.sqlfluff.with({
          extra_args = { "--dialect", "postgres" }, -- change to your dialect
        }),
        require("none-ls.diagnostics.ruff"),
        null_ls.builtins.code_actions.refactoring,
        null_ls.builtins.code_actions.gomodifytags,
      },
    })
    require("mason-null-ls").setup({})
  end,
}
