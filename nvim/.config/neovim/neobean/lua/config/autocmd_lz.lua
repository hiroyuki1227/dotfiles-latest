-- local colors = require("config.colors")

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    -- -- By default wrap is set to true regardless of what I chose in my options.lua file,
    -- -- This sets wrapping for my skitty-notes and I don't want to have
    -- -- wrapping there, I wanto to decide this in the options.lua file
    -- vim.opt_local.wrap = false
    vim.opt_local.spell = true
  end,
})

-- When I open markdown files I want to fold the markdown headings
-- Originally I thought about using it only for skitty-notes, but I think I want
-- it in all markdown files
--
-- if vim.g.neovim_mode == "skitty" then
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.md",
  callback = function()
    -- Get the full path of the current file
    local file_path = vim.fn.expand("%:p")
    -- Ignore files in my daily note directory
    if file_path:match(os.getenv("HOME") .. "/github/obsidian/250%-daily/") then
      return
    end -- Avoid running zk multiple times for the same buffer
    if vim.b.zk_executed then
      return
    end
    vim.b.zk_executed = true -- Mark as executed
    -- Use `vim.defer_fn` to add a slight delay before executing `zk`
    vim.defer_fn(function()
      vim.cmd("normal zk")
      -- This write was disabling my inlay hints
      -- vim.cmd("silent write")
      vim.notify("Folded keymaps", vim.log.levels.INFO)
    end, 100) -- Delay in milliseconds (100ms should be enough)
  end,
})

-- Clear jumps when I open Neovim, otherwise there'a lot of crap that links to
-- different files, trying this and will see if it works out or not
-- vim.api.nvim_create_autocmd("BufWinEnter", {
--   once = true,
--   callback = function()
--     vim.schedule(function()
--       vim.cmd("clearjumps")
--     end)
--   end,
-- })
--
-- local group = vim.api.nvim_create_augroup("MyQMK", {})
--
-- vim.api.nvim_create_autocmd("BufEnter", {
--   desc = "Format glove80",
--   group = group,
--   pattern = "*/linkarzu-glove80/config/glove80.keymap", -- this is a pattern to match the filepath of whatever board you wish to target
--   callback = function()
--     require("qmk").setup({
--       name = "LAYOUT_glove80",
--       variant = "zmk",
--       auto_format_pattern = "*/linkarzu-glove80/config/glove80.keymap",
--       layout = {
--         "x x x x x _ _ _ _ _ _ _ _ _ x x x x x",
--         "x x x x x x _ _ _ _ _ _ _ x x x x x x",
--         "x x x x x x _ _ _ _ _ _ _ x x x x x x",
--         "x x x x x x _ _ _ _ _ _ _ x x x x x x",
--         "x x x x x x x x x _ x x x x x x x x x",
--         "x x x x x _ x x x _ x x x _ x x x x x",
--       },
--     })
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("BufEnter", {
--   desc = "Format toucan",
--   group = group,
--   pattern = "*/zmk-keyboard-toucan/config/toucan.keymap", -- this is a pattern to match the filepath of whatever board you wish to target
--   callback = function()
--     require("qmk").setup({
--       name = "LAYOUT_toucan",
--       variant = "zmk",
--       auto_format_pattern = "*/zmk-keyboard-toucan/config/toucan.keymap",
--       layout = {
--         "x x x x x x _ _ _ x x x x x x",
--         "x x x x x x _ _ _ x x x x x x",
--         "x x x x x x _ _ _ x x x x x x",
--         "_ _ _ _ x x x _ x x x _ _ _ _",
--       },
--     })
--   end,
-- })

-- -- In case you want to disable spell
-- vim.api.nvim_create_autocmd("FileType", {
--   group = augroup("wrap_spell"),
--   pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
--   callback = function()
--     vim.opt_local.spell = false
--   end,
-- })

-- Render markdown codelens on the same line.
-- Nvim 0.12 built-in codelens renders above the target line.
-- To switch back to built-in rendering:
-- vim.lsp.codelens.enable(true, { bufnr = bufnr })
local markdown_codelens_ns = vim.api.nvim_create_namespace("markdown_codelens_inline")
local code_lens_method = vim.lsp.protocol.Methods.textDocument_codeLens or "textDocument/codeLens"
local function refresh_markdown_codelens(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype ~= "markdown" then
    vim.api.nvim_buf_clear_namespace(bufnr, markdown_codelens_ns, 0, -1)
    return
  end
  if #vim.lsp.get_clients({ bufnr = bufnr, method = code_lens_method }) == 0 then
    return
  end
  vim.lsp.codelens.enable(false, { bufnr = bufnr })
  vim.api.nvim_buf_clear_namespace(bufnr, markdown_codelens_ns, 0, -1)
  local params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }
  vim.lsp.buf_request_all(bufnr, code_lens_method, params, function(results)
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end
    vim.api.nvim_buf_clear_namespace(bufnr, markdown_codelens_ns, 0, -1)
    local by_line = {}
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    for _, response in pairs(results) do
      for _, lens in ipairs(response.result or {}) do
        local title = lens.command and lens.command.title
        local row = lens.range and lens.range.start.line
        if title and row and row >= 0 and row < line_count then
          by_line[row] = by_line[row] or {}
          table.insert(by_line[row], title)
        end
      end
    end
    for row, titles in pairs(by_line) do
      vim.api.nvim_buf_set_extmark(bufnr, markdown_codelens_ns, row, 0, {
        virt_text = { { " " .. table.concat(titles, " | "), "LspCodeLens" } },
        virt_text_pos = "eol",
        hl_mode = "combine",
      })
    end
  end)
end
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave", "LspAttach" }, {
  callback = function(args)
    refresh_markdown_codelens(args.buf)
  end,
})
