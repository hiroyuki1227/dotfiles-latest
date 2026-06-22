-- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/plugins/snacks.lua
-- ~/github/dotfiles-latest/neovim/neobean/lua/plugins/snacks.lua

-- https://github.com/folke/snacks.nvim/blob/main/docs/lazygit.md
-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
-- https://github.com/folke/snacks.nvim/blob/main/docs/image.md

-- NOTE: If you experience an issue in which you cannot select a file with the
-- snacks picker when you're in insert mode, only in normal mode, and you use
-- the bullets.vim plugin, that's the cause, go to that file to see how to
-- resolve it
-- https://github.com/folke/snacks.nvim/issues/812

local function normalize_path(path)
  if type(path) ~= "string" or path == "" then
    return nil
  end
  local expanded = vim.fn.expand(path)
  local resolved = vim.uv.fs_realpath(expanded)
  return resolved or vim.fs.normalize(expanded)
end

local function get_work_main_dir()
  local work_env_file = vim.fn.expand("~/github/dotfiles-private/work/work-env.sh")
  if vim.fn.filereadable(work_env_file) == 0 then
    return nil
  end
  local lines = vim.fn.readfile(work_env_file)
  for _, line in ipairs(lines) do
    local value = line:match("^%s*export%s+WORK_MAIN_DIR=(.+)%s*$")
    if value then
      value = value:gsub('^"(.*)"$', "%1")
      value = value:gsub("^'(.*)'$", "%1")
      value = value:gsub("%$HOME", vim.env.HOME or "")
      return normalize_path(value)
    end
  end
end

local function is_work_tree(path)
  local cwd = normalize_path(path)
  local work_main_dir = get_work_main_dir()
  if not cwd or not work_main_dir then
    return false
  end
  return cwd == work_main_dir or vim.startswith(cwd, work_main_dir .. "/")
end

local default_sort_fields = { "score:desc", "mtime:desc", "#text", "idx" }
local work_sort_fields = { "#text", "mtime:desc", "score:desc", "idx" }
local modified_sort_fields = { "mtime:desc" }

local function add_mtime(item)
  local file = item.file
  if type(file) ~= "string" then
    return item
  end
  local uv = vim.uv or vim.loop
  local path = (type(item.cwd) == "string" and (item.cwd .. "/" .. file)) or file
  local stat = uv.fs_stat(path)
  item.mtime = (stat and stat.mtime and stat.mtime.sec) or 0
  return item
end

return {
  {
    "folke/snacks.nvim",
    keys = {
      -- I use this keymap with mini.files, but snacks explorer was taking over
      -- https://github.com/folke/snacks.nvim/discussions/949
      { "<leader>e", false },
      {
        "<leader>sg",
        function()
          Snacks.picker.grep({
            -- Exclude results from grep picker
            -- I think these have to be specified in gitignore syntax
            exclude = { "dictionaries/words.txt" },
          })
        end,
        desc = "Grep",
      },
      -- Open git log in vertical view
      {
        "<leader>gl",
        function()
          Snacks.picker.git_log({
            finder = "git_log",
            format = "git_log",
            preview = "git_show",
            confirm = "git_checkout",
            layout = "vertical",
          })
        end,
        desc = "Git Log",
      },
      -- -- Iterate through incomplete tasks in Snacks_picker
      {
        -- -- You can confirm in your teminal lamw26wmal with:
        "<leader>tt",
        function()
          Snacks.picker.grep({
            prompt = " ",
            -- pass your desired search as a static pattern
            search = "^\\s*- \\[ \\]",
            -- we enable regex so the pattern is interpreted as a regex
            regex = true,
            -- no “live grep” needed here since we have a fixed pattern
            live = false,
            -- restrict search to the current working directory
            dirs = { vim.fn.getcwd() },
            -- I want to filter this to only show markdown files
            glob = "*.md",
            -- include files ignored by .gitignore
            args = { "--no-ignore" },
            -- -- Start in normal mode
            -- on_show = function()
            --   vim.cmd.stopinsert()
            -- end,
            finder = "grep",
            format = "file",
            show_empty = true,
            supports_live = false,
            layout = "ivy_split",
            actions = {
              task_done = function(picker, item)
                picker:norm(function()
                  item = item or picker:current()
                  local path = item and Snacks.picker.util.path(item)
                  local line = item and item.pos and item.pos[1]
                  if not path or not line then
                    vim.notify("No task selected", vim.log.levels.WARN)
                    return
                  end
                  local changed = require("config.modules.markdown_tasks").toggle_done({
                    file = path,
                    line = line,
                  })
                  if changed then
                    picker:refresh()
                  end
                end)
              end,
            },
            win = {
              input = {
                keys = {
                  ["<M-x>"] = { "task_done", mode = { "n", "i" } },
                },
              },
              list = {
                keys = {
                  ["<M-x>"] = "task_done",
                },
              },
            },
          })
        end,
        desc = "[P]Search for incomplete tasks",
      },
      -- -- Iterate throuth completed tasks in Snacks_picker lamw26wmal
      {
        "<leader>tc",
        function()
          Snacks.picker.grep({
            prompt = " ",
            -- pass your desired search as a static pattern
            -- search = "^\\s*- \\[x\\] `done:",
            search = "^\\s*- \\[[xX]\\](?: `done:)?",
            -- we enable regex so the pattern is interpreted as a regex
            regex = true,
            -- no “live grep” needed here since we have a fixed pattern
            live = false,
            -- restrict search to the current working directory
            dirs = { vim.fn.getcwd() },
            -- include files ignored by .gitignore
            args = { "--no-ignore" },
            -- Start in normal mode
            on_show = function()
              vim.cmd.stopinsert()
            end,
            finder = "grep",
            format = "file",
            transform = add_mtime,
            matcher = {
              sort_empty = true,
            },
            sort = {
              fields = modified_sort_fields,
            },
            show_empty = true,
            supports_live = false,
            layout = "ivy",
          })
        end,
        desc = "[P]Search for complete tasks",
      },
      {
        "<leader>ti",
        function()
          Snacks.picker.grep({
            prompt = " ",
            -- pass your desired search as a static pattern
            search = "vid-id$",
            -- we enable regex so the pattern is interpreted as a regex
            regex = true,
            -- no “live grep” needed here since we have a fixed pattern
            live = false,
            -- restrict search to the current working directory
            dirs = { vim.fn.getcwd() },
            -- include files ignored by .gitignore
            args = { "--no-ignore" },
            -- -- Start in normal mode
            -- on_show = function()
            --   vim.cmd.stopinsert()
            -- end,
            finder = "grep",
            format = "file",
            show_empty = true,
            supports_live = false,
            layout = "ivy",
          })
        end,
        desc = "[P]Search for video ideas",
      },
      -- -- List git branches with Snacks_picker to quickly switch to a new branch
      {
        "<M-b>",
        function()
          Snacks.picker.git_branches({
            layout = "select",
          })
        end,
        desc = "Branches",
      },
      -- Used in LazyVim to view the different keymaps, this by default is
      -- configured as <leader>sk but I run it too often
      -- Sometimes I need to see if a keymap is already taken or not
      {
        "<M-k>",
        function()
          Snacks.picker.keymaps({
            layout = "vertical",
          })
        end,
        desc = "Keymaps",
      },
      -- -- File picker
      -- {
      --   "<leader><space>",
      --   function()
      --     local cwd = vim.fn.getcwd()
      --     local sort_fields = default_sort_fields
      --     if is_work_tree(cwd) then
      --       sort_fields = work_sort_fields
      --     end
      --     Snacks.picker.files({
      --       -- Test sorting by most recently modified file first.
      --       -- `mtime` is computed per item in `transform`, then used by `sort.fields`.
      --       transform = function(item)
      --         local file = item.file
      --         if type(file) ~= "string" then
      --           return item
      --         end
      --         local uv = vim.uv or vim.loop
      --         local item_cwd = item.cwd
      --         ---@type string
      --         local path = (type(item_cwd) == "string" and (item_cwd .. "/" .. file)) or file
      --         local stat = uv.fs_stat(path)
      --         item.mtime = (stat and stat.mtime and stat.mtime.sec) or 0
      --         return item
      --       end,
      --       sort = {
      --         fields = sort_fields,
      --       },
      --       finder = "files",
      --       format = "file",
      --       show_empty = true,
      --       supports_live = true,
      --       exclude = { "*.xlsx", "*.txt" },
      --       -- In case you want to override the layout for this keymap
      --       -- layout = "vscode",
      --     })
      --   end,
      --   desc = "Find Files",
      -- },
      -- -- I'm duplicating this keymap as I want to keep my origginal code in case
      -- -- I decidee to come back to snacks
      -- { "<leader><space>", false },
      {
        "<leader><space>",
        function()
          Snacks.picker.smart({})
        end,
      },
      -- Navigate my buffers
      {
        "<S-h>",
        function()
          Snacks.picker.buffers({
            -- I always want my buffers picker to start in normal mode
            on_show = function()
              vim.cmd.stopinsert()
            end,
            finder = "buffers",
            format = "buffer",
            hidden = false,
            unloaded = true,
            current = true,
            sort_lastused = true,
            win = {
              input = {
                keys = {
                  ["d"] = "bufdelete",
                },
              },
              list = { keys = { ["d"] = "bufdelete" } },
            },
            -- In case you want to override the layout for this keymap
            -- layout = "ivy",
          })
        end,
        desc = "[P]Snacks picker buffers",
      },
    },
    opts = {
      -- Documentation for the picker
      -- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
      picker = {
        -- My ~/github/dotfiles-latest/neovim/lazyvim/lua/config/keymaps.lua
        -- file was always showing at the top, I needed a way to decrease its
        -- score, in frecency you could use :FrecencyDelete to delete a file
        -- from the database, here you can decrease it's score
        transform = function(item)
          if not item.file then
            return item
          end
          -- Demote the "lazyvim" keymaps file:
          if item.file:match("lazyvim/lua/config/keymaps%.lua") then
            item.score_add = (item.score_add or 0) - 30
          end
          -- Demote my old kanata config file
          if item.file:match("kanata/configs/macos%.kbd") then
            item.score_add = (item.score_add or 0) - 30
          end
          -- Boost the "neobean" keymaps file:
          -- if item.file:match("neobean/lua/config/keymaps%.lua") then
          --   item.score_add = (item.score_add or 0) + 100
          -- end
          return item
        end,
        -- In case you want to make sure that the score manipulation above works
        -- or if you want to check the score of each file
        debug = {
          scores = false, -- show scores in the list
        },
        -- I like the "ivy" layout, so I set it as the default globaly, you can
        -- still override it in different keymaps
        layout = {
          preset = "ivy",
          -- When reaching the bottom of the results in the picker, I don't want
          -- it to cycle and go back to the top
          cycle = false,
        },
        layouts = {
          -- I wanted to modify the ivy layout height and preview pane width,
          -- this is the only way I was able to do it
          -- NOTE: I don't think this is the right way as I'm declaring all the
          -- other values below, if you know a better way, let me know
          --
          -- Then call this layout in the keymaps above
          -- got example from here
          -- https://github.com/folke/snacks.nvim/discussions/468
          ivy = {
            layout = {
              box = "vertical",
              backdrop = false,
              row = -1,
              width = 0,
              height = 0.7,
              border = "top",
              title = " {title} {live} {flags}",
              title_pos = "left",
              { win = "input", height = 1, border = "bottom" },
              {
                box = "horizontal",
                { win = "list", border = "none" },
                { win = "preview", title = "{preview}", width = 0.5, border = "left" },
              },
            },
          },
          -- I wanted to modify the layout height, I wanted it bigger (that's
          -- what she said)
          ivy_split = {
            layout = {
              box = "vertical",
              backdrop = false,
              width = 0,
              height = 0.6,
              position = "bottom",
              border = "top",
              title = " {title} {live} {flags}",
              title_pos = "left",
              { win = "input", height = 1, border = "bottom" },
              {
                box = "horizontal",
                { win = "list", border = "none" },
                { win = "preview", title = "{preview}", width = 0.6, border = "left" },
              },
            },
          },
          -- I wanted to modify the layout width
          vertical = {
            layout = {
              backdrop = false,
              width = 0.8,
              min_width = 80,
              height = 0.8,
              min_height = 30,
              box = "vertical",
              border = "rounded",
              title = "{title} {live} {flags}",
              title_pos = "center",
              { win = "input", height = 1, border = "bottom" },
              { win = "list", border = "none" },
              { win = "preview", title = "{preview}", height = 0.4, border = "top" },
            },
          },
        },
        matcher = {
          frecency = true,
        },
        win = {
          input = {
            keys = {
              -- to close the picker on ESC instead of going to normal mode,
              -- add the following keymap to your config
              ["<Esc>"] = { "close", mode = { "n", "i" } },
              -- I'm used to scrolling like this in LazyGit
              ["J"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["K"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["H"] = { "preview_scroll_left", mode = { "i", "n" } },
              ["L"] = { "preview_scroll_right", mode = { "i", "n" } },
            },
          },
        },
        formatters = {
          file = {
            filename_first = true, -- display filename before the file path
            truncate = 80,
          },
        },
      },
      -- Folke pointed me to the snacks docs
      -- https://github.com/LazyVim/LazyVim/discussions/4251#discussioncomment-11198069
      -- Here's the lazygit snak docs
      -- https://github.com/folke/snacks.nvim/blob/main/docs/lazygit.md
      lazygit = {
        theme = {
          selectedLineBgColor = { bg = "CursorLine" },
        },
        -- With this I make lazygit to use the entire screen, because by default there's
        -- "padding" added around the sides
        -- I asked in LazyGit, folke didn't like it xD xD xD
        -- https://github.com/folke/snacks.nvim/issues/719
        win = {
          -- -- The first option was to use the "dashboard" style, which uses a
          -- -- 0 height and width, see the styles documentation
          -- -- https://github.com/folke/snacks.nvim/blob/main/docs/styles.md
          -- style = "dashboard",
          -- But I can also explicitly set them, which also works, what the best
          -- way is? Who knows, but it works
          width = 0,
          height = 0,
        },
      },
      notifier = {
        enabled = true,
        top_down = false, -- place notifications from top to bottom
      },
      -- This keeps the image on the top right corner, basically leaving your
      -- text area free, suggestion found in reddit by user `Redox_ahmii`
      -- https://www.reddit.com/r/neovim/comments/1irk9mg/comment/mdfvk8b/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
      styles = {
        snacks_image = {
          relative = "editor",
          col = -1,
        },
      },
      image = {
        enabled = true,
        doc = {
          -- Personally I set this to false, I don't want to render all the
          -- images in the file, only when I hover over them
          -- render the image inline in the buffer
          -- if your env doesn't support unicode placeholders, this will be disabled
          -- takes precedence over `opts.float` on supported terminals
          inline = false,
          -- only_render_image_at_cursor = vim.g.neovim_mode == "skitty" and false or true,
          -- render the image in a floating window
          -- only used if `opts.inline` is disabled
          float = true,
          -- Sets the size of the image
          -- max_width = 60,
          -- max_width = vim.g.neovim_mode == "skitty" and 20 or 60,
          -- max_height = vim.g.neovim_mode == "skitty" and 10 or 30,
          max_width = 60,
          max_height = 30,
          -- max_height = 30,
          -- Apparently, all the images that you preview in neovim are converted
          -- to .png and they're cached, original image remains the same, but
          -- the preview you see is a png converted version of that image
          --
          -- Where are the cached images stored?
          -- This path is found in the docs
          -- :lua print(vim.fn.stdpath("cache") .. "/snacks/image")
          -- For me returns `~/.cache/neobean/snacks/image`
          -- Go 1 dir above and check `sudo du -sh ./* | sort -hr | head -n 5`
        },
      },
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
      --       dashboard = {
      --         -- enabled = vim.g.scrollback_mode ~= "neobean", -- Disable for scrollback_mode
      --         enabled = vim.g.scrollback_mode ~= "neobean" and vim.g.simpler_scrollback ~= "deeznuts",
      --         preset = {
      --           keys = {
      --             -- { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
      --             -- { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
      --             -- { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
      --             -- { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
      --             -- {
      --             --   icon = " ",
      --             --   key = "c",
      --             --   desc = "Config",
      --             --   action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
      --             -- },
      --             { icon = " ", key = "s", desc = "Restore Session", section = "session" },
      --             -- { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
      --             { icon = " ", key = "<esc>", desc = "Quit", action = ":qa" },
      --           },
      --           -- Font Name: ANSI Shadow
      --           -- https://patorjk.com/software/taag
      --           header = [[
      -- ███╗   ██╗███████╗ ██████╗ ██████╗ ███████╗ █████╗ ███╗   ██╗
      -- ████╗  ██║██╔════╝██╔═══██╗██╔══██╗██╔════╝██╔══██╗████╗  ██║
      -- ██╔██╗ ██║█████╗  ██║   ██║██████╔╝█████╗  ███████║██╔██╗ ██║
      -- ██║╚██╗██║██╔══╝  ██║   ██║██╔══██╗██╔══╝  ██╔══██║██║╚██╗██║
      -- ██║ ╚████║███████╗╚██████╔╝██████╔╝███████╗██║  ██║██║ ╚████║
      -- ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝
      --
      -- [Linkarzu.com]
      --         ]],
      --         },
      --       },
    },
  },
}
