return {
  {
    "yetone/avante.nvim",
    enabled = true,
    event = "VeryLazy",
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    lazy = false,
    opts = {
      provider = "ollama",
      -- openai = {
      --   endpoint = "https://api.openai.com/v1",
      --   model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
      --   timeout = 30000, -- timeout in milliseconds
      --   temperature = 0, -- adjust if needed
      --   max_tokens = 4096,
      --   -- reasoning_effort = "high" -- only supported for reasoning models (o1, etc.)
      -- },
      auto_suggestions_provider = "ollama",
      behaviour = {
        auto_suggestions = true, -- 自動提案を有効化
        auto_set_highlight_group = true, -- ハイライト具ルプを自動設定
        auto_set_keymaps = true, -- キーマップを自動設定
        auto_apply_diff_after_generation = true, -- 生成後に差分を自動適用
        support_paste_from_clipboard = true, -- クリップボードからの貼り付けをサポート
        minimize_diff = true, -- 差分を最小化
      },
      windows = {
        position = "right",
        wrap = true,
        width = 30,
        sidebar_header = {
          align = "center",
          enabbled = true,
          rounded = false,
        },
        input = {
          prefix = "> ",
          height = 8,
        },
        edit = {
          border = "rounded",
          start_insert = true,
        },
        ask = {
          floating = true,
          start_insert = true,
          border = "rounded",
          fucus_on_apply = "ours",
        },
      },
      ollama = {
        endpoint = "http://127.0.0.1:11434", -- Note that there is no /v1 at the end.
        -- model = "deepseek-r1:latest",
        -- model = "phi4:14b","
        model = "gemma3:4b",
      },

      -- other config
      -- The system_prompt type supports both a string and a function that returns a string. Using a function here allows dynamically updating the prompt with mcphub
      system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        return hub:get_active_servers_prompt()
      end,
      -- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
      custom_tools = function()
        return {
          require("mcphub.extensions.avante").mcp_tool(),
        }
      end,
    },
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "nvim-tree/nvim-web-devicons",
      -- "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante", "codecompanion" },
        },
        ft = { "markdown", "Avante", "codecompanion", "markdown.mdx" },
      },
    },
    --   -- 🔥 Dressing.nvim (UI Enhancements)
    --   {
    --     "stevearc/dressing.nvim",
    --     lazy = true,
    --     opts = {
    --       input = { enabled = false },
    --       select = { enabled = false },
    --     },
    --   },
    --
    --   -- 🎯 Blink Completion Framework
    --   {
    --     "saghen/blink.compat",
    --     lazy = false, -- Changed to load immediately
    --     opts = {},
    --   },
  },
}
