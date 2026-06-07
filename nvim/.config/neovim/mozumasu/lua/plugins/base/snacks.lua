return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    config = function(_, opts)
      require("snacks").setup(opts)

      -- Auto show image on cursor hold
      vim.api.nvim_create_autocmd("CursorHold", {
        group = vim.api.nvim_create_augroup("snacks_image_hover", { clear = true }),
        pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.md", "*.markdown" },
        callback = function()
          if Snacks and Snacks.image and Snacks.image.hover then
            -- Safely call hover, ignore errors if no image at cursor
            pcall(Snacks.image.hover)
          end
        end,
      })

      -- Optional: Reduce updatetime for faster hover (default is 4000ms)
      vim.opt.updatetime = 300 -- CursorHold発火間隔（100msは短すぎてフリーズ原因になりやすい）
    end,
    keys = {
      {
        "<leader>mp",
        ft = { "png", "markdown" },
        function()
          Snacks.image.hover()
        end,
        desc = "Preview image/math formula under cursor (manual)",
      },
      {
        "<leader>p",
        function()
          Snacks.picker.pickers()
        end,
      },
      {
        "<space>fh",
        function()
          Snacks.picker.help({
            win = {
              input = { keys = {
                ["<CR>"] = { "edit_vsplit", mode = { "i", "n" } },
              } },
            },
          })
        end,
        desc = "Picker: help pages",
      },
      {
        "<leader>gf",
        function()
          Snacks.picker.git_log_file({
            confirm = function(picker, item)
              if item and item.commit then
                Snacks.gitbrowse({ commit = item.commit })
              end
            end,
          })
        end,
        desc = "Git Log File (Enter=Browse, o=Checkout)",
      },
      {
        "<leader>gD",
        function()
          Snacks.picker.git_diff({ base = "main" })
        end,
        desc = "Git Diff vs Main",
      },
    },
    ---@type snacks.Config
    opts = {
      scroll = { enabled = false },
      dashboard = {
        enabled = true,
        width = 60,
        row = nil,
        col = nil,
        pane_gap = 10, -- SPACE BETWEEN LEFT AND RIGHT COLUMNS
        preset = {
          -- Use fzf-lua as the picker
          pick = function(cmd, opts)
            local fzf = require("fzf-lua")
            opts = opts or {}
            if cmd == "files" then
              fzf.files(opts)
            elseif cmd == "live_grep" then
              fzf.live_grep(opts)
            elseif cmd == "oldfiles" then
              fzf.oldfiles(opts)
            end
          end,
          -- Custom keymaps with proper icons
          keys = {
            { icon = "󰝒 ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = "󰝒", key = "n", desc = " New File", action = ": ene | startinsert" },
            {
              icon = " ",
              key = "g",
              desc = "Find Text",
              action = ":lua Snacks.dashboard.pick('live_grep')",
            },
            {
              icon = " ",
              key = "r",
              desc = "Recent Files",
              action = ": lua Snacks.dashboard.pick('oldfiles')",
            },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ": lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            {
              icon = "󰒲 ",
              key = "l",
              desc = "Lazy",
              action = ": Lazy",
              enabled = package.loaded.lazy ~= nil,
            },
            { icon = " ", key = "q", desc = "Quit", action = ": qa" },
          },

          -- NEOVIM header
          header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        },

        -- ============================================================
        -- FORMATS SECTION - CONTROLS HOW ITEMS ARE DISPLAYED
        -- This removes the space between icon and text
        -- ============================================================
        formats = {
          key = function(item)
            return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
          end,
          icon = function(item)
            if item.file and (item.icon == "file" or item.icon == "directory") then
              -- Get the actual icon from nvim-web-devicons instead of using item.icon
              local icon, hl = require("nvim-web-devicons").get_icon(item.file, nil, { default = true })
              return { { icon or " ", hl = hl or "icon" } } -- Return as table of tables, no width property
            end
            return { { item.icon, hl = "icon" } } -- Return as table of tables
          end,
        },
        -- Two-pane layout
        sections = {
          { pane = 2, text = " ", padding = -10 }, -- Negative padding pulls it UP
          -- ============================================================
          -- LEFT COLUMN: NEOVIM ASCII HEADER AT TOP
          -- ============================================================
          { section = "header" },

          -- ============================================================
          -- RIGHT COLUMN: COLORFUL BLOCKS AT TOP
          -- Using colorscript for beautiful colored squares
          -- padding = space above/below this section
          -- INCREASE padding TO PUSH RIGHT SIDE DOWN
          -- ============================================================
          {
            pane = 2, -- pane = 2 means RIGHT column
            section = "terminal",
            cmd = "colorscript -e square", -- Colorful square pattern
            height = 5,
            padding = 1, -- CHANGE THIS TO PUSH RIGHT SIDE DOWN (try 8)
          },

          -- ============================================================
          -- LEFT COLUMN: MENU BUTTONS (Find File, New File, etc.)
          -- gap = space BETWEEN each menu item
          -- padding = space ABOVE and BELOW all menu items
          -- ============================================================
          {
            section = "keys",
            gap = 1, -- SPACE BETWEEN "Find File", "New File", etc.
            padding = 1, -- SPACE ABOVE/BELOW ENTIRE MENU
          },

          -- ============================================================
          -- RIGHT COLUMN: RECENT FILES SECTION
          -- indent = left spacing for file list
          -- padding = space ABOVE this section
          -- ============================================================
          {
            pane = 2, -- RIGHT column
            icon = "",
            title = "Recent Files",
            section = "recent_files",
            indent = 2, -- LEFT INDENT FOR FILE ITEMS
            padding = { 1, 1 }, -- SPACE ABOVE "Recent Files" title
            limit = 5,
          },

          -- ============================================================
          -- RIGHT COLUMN: PROJECTS SECTION
          -- ============================================================
          {
            pane = 2, -- RIGHT column
            icon = "󰉓",
            title = "Projects",
            section = "projects",
            indent = 2, -- LEFT INDENT FOR PROJECT ITEMS
            padding = { 1, 1 }, -- SPACE ABOVE "Projects" title
            limit = 4,
          },

          -- ============================================================
          -- RIGHT COLUMN: GIT STATUS SECTION
          -- ============================================================
          {
            pane = 2, -- RIGHT column
            icon = "",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "echo '' && git status --short --branch --renames",
            height = 6,
            padding = { 1, 1 }, -- SPACE ABOVE "Git Status" title
            ttl = 5 * 60,
            indent = 3, -- LEFT INDENT FOR GIT STATUS ITEMS
          },

          -- ============================================================
          -- FOOTER: "Neovim loaded X plugins" AT BOTTOM
          -- ============================================================
          { section = "startup" },
        },
      },
      -- dashboard = {
      --   preset = {
      --     keys = {
      --       {
      --         icon = " ",
      --         key = "f",
      --         desc = "Find File",
      --         action = function()
      --           local cwd = vim.fn.getcwd()
      --           local hidden = cwd:match("dotfiles$") ~= nil
      --           Snacks.picker.files({ cwd = cwd, hidden = hidden })
      --         end,
      --       },
      --       { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
      --       {
      --         icon = " ",
      --         key = "g",
      --         desc = "Find Text",
      --         action = function()
      --           local cwd = vim.fn.getcwd()
      --           local hidden = cwd:match("dotfiles$") ~= nil
      --           Snacks.picker.grep({ cwd = cwd, hidden = hidden })
      --         end,
      --       },
      --       {
      --         icon = " ",
      --         key = "r",
      --         desc = "Recent Files",
      --         action = function()
      --           Snacks.picker.recent()
      --         end,
      --       },
      --       {
      --         icon = " ",
      --         key = "c",
      --         desc = "Config",
      --         action = function()
      --           Snacks.picker.files({ cwd = vim.fn.stdpath("config"), hidden = true })
      --         end,
      --       },
      --       { icon = " ", key = "s", desc = "Restore Session", section = "session" },
      --       { icon = "󰒲 ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
      --       { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
      --       { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      --     },
      --   },
      -- },
      image = {
        enabled = true,
        -- nb の --original URL形式を実際のファイルパスに変換
        resolve = function(file, src)
          -- http://localhost:6789/--original/{notebook}/{filename} 形式を検出
          local notebook, filename = src:match("http://localhost:6789/%-%-original/([^/]+)/(.+)$")
          if notebook and filename then
            local nb = require("config.nb")
            return nb.get_nb_dir() .. "/" .. notebook .. "/" .. filename
          end
          return nil
        end,
        doc = {
          -- enable image viewer for documents
          -- a treesitter parser must be available for the enabled languages.
          -- supported language injections: markdown, html
          enabled = true,
          -- render the image inline in the buffer
          -- if your env doesn't support unicode placeholders, this will be disabled
          -- takes precedence over `opts.float` on supported terminals
          inline = true,
          -- render the image in a floating window
          -- only used if `opts.inline` is disabled
          float = false,
          max_width = 80,
          max_height = 40,
        },
      },
      picker = {
        win = {
          input = {
            keys = {
              ["h"] = { "toggle_hidden", mode = { "n" } },
              ["I"] = { "toggle_ignored", mode = { "n" } },
            },
          },
        },
        sources = {
          git_log_file = {
            focus = "list", -- Default focus to the list
            win = {
              list = {
                keys = {
                  ["o"] = "git_checkout",
                },
              },
            },
          },
        },
      },
    },
  },
}
