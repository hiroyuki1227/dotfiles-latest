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

  -- codeium
  {
    "Exafunction/codeium.nvim",
    event = "BufEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      -- require("codeium").setup({

      -- })
      vim.keymap.set("i", "<C-g>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-;>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-,>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-x>", function()
        return vim.fn["codeium#Clear"]()
      end, { expr = true, silent = true })
      vim.g.codeium_filetype = {
        markdown = false,
      }
    end,
    -- "Exafunction/codeium.nvim"{
    --   event = "BufEnter",
    --   dependencies = {
    --     "nvim-lua/plenary.nvim",
    --     "hrsh7th/nvim-cmp",
    --   },
    --   config = function()
    --     -- Change '<C-g>' here to any keycode you like.
    --     vim.keymap.set("i", "<C-g>", function()
    --       return vim.fn["codeium#Accept"]()
    --     end, { expr = true, silent = true })
    --     vim.keymap.set("i", "<c-;>", function()
    --       return vim.fn["codeium#CycleCompletions"](1)
    --     end, { expr = true, silent = true })
    --     vim.keymap.set("i", "<c-,>", function()
    --       return vim.fn["codeium#CycleCompletions"](-1)
    --     end, { expr = true, silent = true })
    --     vim.keymap.set("i", "<c-x>", function()
    --       return vim.fn["codeium#Clear"]()
    --     end, { expr = true, silent = true })
    --     vim.g.codeium_filetype = {
    --       markdown = false,
    --     }
    --   end,
  },
}
