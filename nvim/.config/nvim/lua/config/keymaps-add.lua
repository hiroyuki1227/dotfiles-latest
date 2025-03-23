-- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/config/keymaps.lua
-- ~/github/dotfiles-latest/neovim/neobean/lua/config/keymaps.lua

local M = {}

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- -- Leaving this here as an example in case you want to delete default keymaps
-- -- delete default buffer navigation keymaps
-- vim.keymap.del("n", "<S-h>")
-- vim.keymap.del("n", "<S-l>")

-- I don't want to switch between buffers anymore, instead I'll use BufExplorer
-- For this to work, make sure you have the plugin installed
-- vim.keymap.set("n", "<S-h>", "<cmd>BufExplorer<cr>", { desc = "[P]Open bufexplorer" })

-- I was running out of Ctrl keys that I use for several things, like pasting
-- images intoa file using img-clip.nvim, or uploading images to imgur, pasting
-- the path of a file to the clipboard, etc, so I switched all of those ctrl
-- keys to alt, you just need to configure your terminal emulator for that lamw25wmal,
-- I configured both Ghostty and Kitty to just treat the right option key as alt
-- in macOS, I still use the left option key for unicode characters, like ñ ó á
-- and stuff like that in spanish, you pinchis gringos wouldn't understand

-- By default lazygit opens with <leader>gg, but I use it way too much, so need
-- something faster
if vim.fn.executable("lazygit") == 1 then
	vim.keymap.set("n", "<M-g>", function()
		Snacks.lazygit({ cwd = LazyVim.root.git() })
	end, { desc = "Lazygit (Root Dir)" })
end

-- This is using the kdheepak/lazygit.nvim file, the only reason I use it, is
-- because the window looks bigger
-- vim.keymap.set("n", "<M-g>", ":LazyGit<CR>", { desc = "Lazygit (Root Dir)" })

-- Select the hunk under the cursor, excluding trailing blank line
vim.keymap.set("n", "<M-2>", function()
	require("mini.diff").textobject()
	-- Get the current line content
	local current_line = vim.api.nvim_get_current_line()
	-- If we're on a blank line, move up
	if current_line == "" then
		vim.cmd("normal! k")
	end
end, { desc = "[P]Select Current Hunk in Visual Mode" })

-- Restart Neovim
vim.keymap.set({ "n", "v", "i" }, "<M-R>", function()
	-- Save all modified buffers, autosave may not have kicked in sometimes
	vim.cmd("wall")
	-- Check if a right pane exists, if it does close it
	local has_panes = vim.fn.system("tmux list-panes | wc -l"):gsub("%s+", "") ~= "1"
	if has_panes then
		vim.fn.system("tmux kill-pane -t :.+")
	end
	os.execute('open "btt://execute_assigned_actions_for_trigger/?uuid=481BDF1F-D0C3-4B5A-94D2-BD3C881FAA6F"')
end, { desc = "[P]Restart Neovim via BTT" })

-- Disable this keymap overriding it with a no-operation function (noop)
-- Otherwise when by mistake press <M-r> to restart neovim, it does "r" to
-- replace
vim.keymap.set({ "n", "v", "i" }, "<M-r>", "<Nop>", { desc = "[P] Disabled No operation for <M-r>" })

-- By default, CTRL-U and CTRL-D scroll by half a screen (50% of the window height)
-- Scroll by 35% of the window height and keep the cursor centered
local scroll_percentage = 0.35
-- Scroll by a percentage of the window height and keep the cursor centered
vim.keymap.set("n", "<C-d>", function()
	local lines = math.floor(vim.api.nvim_win_get_height(0) * scroll_percentage)
	vim.cmd("normal! " .. lines .. "jzz")
end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", function()
	local lines = math.floor(vim.api.nvim_win_get_height(0) * scroll_percentage)
	vim.cmd("normal! " .. lines .. "kzz")
end, { noremap = true, silent = true })

-- When jumping with ctrl+d and u the cursors stays in the middle
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<c-u>", "<c-u>zz")

-- Quit or exit neovim, easier than to do <leader>qq
vim.keymap.set({ "n", "v", "i" }, "<M-q>", "<cmd>wqa<cr>", { desc = "[P]Quit All" })

-- -- This, by default configured as <leader>sk but I run it too often lamw25wmal
-- vim.keymap.set({ "n", "v", "i" }, "<M-k>", "<cmd>Telescope keymaps<cr>", { desc = "[P]Key Maps" })

-- -- List git branches with telescope to quickly switch to a new branch
-- vim.keymap.set("n", "<M-b>", function()
--   require("telescope.builtin").git_branches(require("telescope.themes").get_ivy({
--     initial_mode = "insert",
--     layout_config = {
--       -- Adjust the preview width for better visibility
--       preview_width = 0.5,
--     },
--     attach_mappings = function(_, map)
--       -- Remap <Space> to checkout the currently selected branch
--       -- map("i", "<Space>", require("telescope.actions").select_default)
--       map("n", "<Space>", require("telescope.actions").select_default)
--       return true
--     end,
--   }))
-- end, { desc = "[P]Checkout Git branch in telescope" })

vim.keymap.set({ "n", "v", "i" }, "<M-h>", function()
	-- require("noice").cmd("history")
	require("noice").cmd("all")
end, { desc = "[P]Noice History" })

-- Dismiss noice notifications
vim.keymap.set({ "n", "v", "i" }, "<M-d>", function()
	require("noice").cmd("dismiss")
end, { desc = "Dismiss All" })

-- HACK: Manage Markdown tasks in Neovim similar to Obsidian | Telescope to List Completed and Pending Tasks
-- https://youtu.be/59hvZl077hM
--
-- -- Iterate through incomplete tasks in telescope
-- -- You can confirm in your teminal lamw25wmal with:
-- -- rg "^\s*-\s\[ \]" test-markdown.md
-- vim.keymap.set("n", "<leader>tt", function()
--   require("telescope.builtin").grep_string(require("telescope.themes").get_ivy({
--     prompt_title = "Incomplete Tasks",
--     -- search = "- \\[ \\]", -- Fixed search term for tasks
--     -- search = "^- \\[ \\]", -- Ensure "- [ ]" is at the beginning of the line
--     search = "^\\s*- \\[ \\]", -- also match blank spaces at the beginning
--     search_dirs = { vim.fn.getcwd() }, -- Restrict search to the current working directory
--     use_regex = true, -- Enable regex for the search term
--     initial_mode = "normal", -- Start in normal mode
--     layout_config = {
--       preview_width = 0.5, -- Adjust preview width
--     },
--     additional_args = function()
--       return { "--no-ignore" } -- Include files ignored by .gitignore
--     end,
--   }))
-- end, { desc = "[P]Search for incomplete tasks" })

-- HACK: Manage Markdown tasks in Neovim similar to Obsidian | Telescope to List Completed and Pending Tasks
-- https://youtu.be/59hvZl077hM
--
-- -- Iterate throuth completed tasks in telescope lamw25wmal
-- vim.keymap.set("n", "<leader>tc", function()
--   require("telescope.builtin").grep_string(require("telescope.themes").get_ivy({
--     prompt_title = "Completed Tasks",
--     -- search = [[- \[x\] `done:]], -- Regex to match the text "`- [x] `done:"
--     -- search = "^- \\[x\\] `done:", -- Matches lines starting with "- [x] `done:"
--     search = "^\\s*- \\[x\\] `done:", -- also match blank spaces at the beginning
--     search_dirs = { vim.fn.getcwd() }, -- Restrict search to the current working directory
--     use_regex = true, -- Enable regex for the search term
--     initial_mode = "normal", -- Start in normal mode
--     layout_config = {
--       preview_width = 0.5, -- Adjust preview width
--     },
--     additional_args = function()
--       return { "--no-ignore" } -- Include files ignored by .gitignore
--     end,
--   }))
-- end, { desc = "[P]Search for completed tasks" })

-- Commented these 2 as I couldn't clear search results with escape
-- I want to close split panes with escape, the default is "q"
-- vim.keymap.set("n", "<esc>", "<cmd>close<cr>", { desc = "Close split pane" })
-- I also want to close split panes with escape in terminal mode
-- vim.keymap.set("n", "<esc>", "<C-W>c", { desc = "Delete Window", remap = true })

-- HACK: How I navigate between buffers in neovim
-- https://youtu.be/ldfxEda_mzc
--
-- -- I'm switching from bufexplorer to telescope buffers as I get a file preview,
-- -- that's basically the main benefit lamw25wmal
-- vim.keymap.set("n", "<S-h>", function()
--   require("telescope.builtin").buffers(require("telescope.themes").get_ivy({
--     sort_mru = true,
--     -- -- Sorts current and last buffer to the top and selects the lastused (default: false)
--     -- -- Leave this at false, otherwise when put in normal mode, the buffer
--     -- -- below is selected, not the one at the top
--     sort_lastused = false,
--     initial_mode = "normal",
--     -- Pre-select the current buffer
--     -- ignore_current_buffer = false,
--     -- select_current = true,
--     layout_config = {
--       -- Set preview width, 0.7 sets it to 70% of the window width
--       preview_width = 0.45,
--     },
--   }))
-- end, { desc = "[P]Open telescope buffers" })

-- Unfinished attempt ty try to get the final config of a plugin, see reddit:
-- https://www.reddit.com/r/neovim/comments/1hmmfpn/how_can_i_see_the_final_fully_merged_config_of/
vim.keymap.set("n", "<leader>fP", function()
	vim.ui.input({ prompt = "Plugin name: " }, function(plugin_name)
		if not plugin_name or plugin_name == "" then
			return
		end
		-- Create a new buffer for the configuration
		local buf = vim.api.nvim_create_buf(false, true)
		vim.bo[buf].buftype = "nofile"
		vim.bo[buf].bufhidden = "wipe"
		vim.bo[buf].swapfile = false
		vim.bo[buf].filetype = "lua"
		-- Get the plugin configuration
		local plugin_config = require("lazy.core.config").plugins[plugin_name]
		-- Convert the config to string and split into lines
		local header = {
			"Plugin Configuration for: " .. plugin_name,
			"------------------------",
		}
		local config_lines = vim.split(vim.inspect(plugin_config), "\n")
		-- Combine header and config lines
		local all_lines = vim.list_extend(header, config_lines)
		-- Set the buffer content
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, all_lines)
		-- Open in a right split
		vim.cmd("vsplit")
		vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), buf)
	end)
end, { desc = "[P]Inspect plugin merge config" })

-- -- -- Open buffers with fzf-lua
-- vim.keymap.set("n", "<S-h>", function()
--   require("fzf-lua").buffers({
--     sort_mru = true, -- Sort buffers by most recently used
--     sort_lastused = true, -- Sort by last used
--     preview = {
--       layout = "vertical", -- Set preview layout to vertical
--       vertical = "down:45%", -- 45% of window height for the preview
--     },
--   })
-- end, { desc = "[P]fzf-lua buffers" })

-- vim.keymap.del("n", "<S-l>")

-- Snipe has been updated so this keymap changed, I moved the keymap to the
-- snipe plugin file, the only issue as of now is that `max_path_width` is not
-- available, but raised issue https://github.com/leath-dub/snipe.nvim/issues/38
-- vim.keymap.set("n", "<S-l>", function()
--   local toggle = require("snipe").create_buffer_menu_toggler({
--     -- Limit the width of path buffer names
--     max_path_width = 1,
--   })
--   toggle()
-- end, { desc = "[P]Snipe" })

vim.keymap.set("n", "<leader>uk", '<cmd>lua require("kubectl").toggle()<cr>', { noremap = true, silent = true })

-- -- use kj to exit insert mode
-- -- I auto save with
-- --  ~/github/dotfiles-latest/neovim/neobean/lua/plugins/auto-save.lua
vim.keymap.set("i", "kj", "<ESC>", { desc = "[P]Exit insert mode with kj" })

-- -- An alternative way of saving (autosave)
-- -- Auto saving when exiting insert mode with `kj`
-- -- Disabling this because switched over to
-- --  ~/github/dotfiles-latest/neovim/neobean/lua/plugins/auto-save.lua
-- -- And it works :muacks:, beautifully
-- vim.keymap.set("i", "kj", function()
--   -- "Write" saves regardless of whether the buffer has been modified or not
--   -- vim.cmd("write")
--   -- "Update" saves only if the buffer has been modified since the last save
--   -- Suggested in reddit by user @SeoCamo
--   vim.cmd("update")
--   -- Move to the right
--   vim.cmd("normal l")
--   -- Switch back to command mode after saving
--   vim.cmd("stopinsert")
--   -- Print the "File saved" message and the file path
--   -- print("FILE SAVED: " .. vim.fn.expand("%:p"))
-- end, { desc = "[P]Write current file and exit insert mode" })

-- use gh to move to the beginning of the line in normal mode
-- use gl to move to the end of the line in normal mode
vim.keymap.set({ "n", "v" }, "gh", "^", { desc = "[P]Go to the beginning line" })
vim.keymap.set({ "n", "v" }, "gl", "$", { desc = "[P]go to the end of the line" })
--
-- I'm switching from gh to H and gl to L so that I can also use the same
-- bindings in tmux copy mode, because I can't use gh and gl there, I tried
-- Nope, disabled this as I use them for telescope buffers and snipe
-- vim.keymap.set({ "n", "v" }, "H", "^", { desc = "[P]Go to the beginning line" })
-- vim.keymap.set({ "n", "v" }, "L", "$", { desc = "[P]go to the end of the line" })

-- In visual mode, after going to the end of the line, come back 1 character
vim.keymap.set("v", "gl", "$h", { desc = "[P]Go to the end of the line" })

-- -- These are defaults from lazyvim, but I also want them to work in insert mode
-- -- This worked great, but it didn't work with tmux, cannot use those keys to
-- -- switch to tmux panes anymore
-- local function navigate_window(direction)
--   return function()
--     if vim.fn.mode() == "i" then
--       vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc><C-w>" .. direction, true, false, true), "n", true)
--     else
--       vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>" .. direction, true, false, true), "n", true)
--     end
--   end
-- end
-- vim.keymap.set({ "n", "i" }, "<C-h>", navigate_window("h"), { desc = "Go to Left Window", remap = false })
-- vim.keymap.set({ "n", "i" }, "<C-j>", navigate_window("j"), { desc = "Go to Lower Window", remap = false })
-- vim.keymap.set({ "n", "i" }, "<C-k>", navigate_window("k"), { desc = "Go to Upper Window", remap = false })
-- vim.keymap.set({ "n", "i" }, "<C-l>", navigate_window("l"), { desc = "Go to Right Window", remap = false })

-- -- yank selected text into system clipboard
-- -- Vim/Neovim has two clipboards: unnamed register (default) and system clipboard.
-- --
-- -- Yanking with `y` goes to the unnamed register, accessible only within Vim.
-- -- The system clipboard allows sharing data between Vim and other applications.
-- -- Yanking with `"+y` copies text to both the unnamed register and system clipboard.
-- -- The `"+` register represents the system clipboard.
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "[P]Yank to system clipboard" })

-- See the comment in the keymap
local function md_inline_calculator(auto_trigger)
	local line = vim.api.nvim_get_current_line()
	local cursor_col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- 1-based column
	local mode = vim.api.nvim_get_mode().mode
	local expressions = {}
	-- Find all backtick-enclosed expressions
	local start_idx = 1
	while true do
		local expr_start, expr_end = line:find("`([^`]+)`", start_idx)
		if not expr_start then
			break
		end
		table.insert(expressions, {
			start = expr_start + 1,
			finish = expr_end - 1,
			closing = expr_end,
			content = line:sub(expr_start + 1, expr_end - 1),
		})
		start_idx = expr_end + 1
	end
	-- Automatic mode: Check last-closed backtick pair
	if mode == "i" then
		local last_char = line:sub(cursor_col - 1, cursor_col - 1)
		if last_char == "`" then
			for _, expr in ipairs(expressions) do
				if expr.closing == cursor_col - 1 then
					-- Check if content starts with ; and matches allowed characters
					if not expr.content:find("=") and expr.content:match("^;%s*[%d%+%-%*%/%%%s%.%(%)x÷]+$") then
						local success, result = pcall(function()
							return load("return " .. expr.content:gsub("x", "*"):gsub("÷", "/"):sub(2))()
						end)
						if success then
							local cleaned = expr.content:sub(2):gsub("^%s*", "")
							local replacement = string.format("%s=%s", cleaned, result)
							local new_line = line:sub(1, expr.start - 1) .. replacement .. line:sub(expr.finish + 1)
							vim.api.nvim_set_current_line(new_line)
							vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), expr.start + #replacement })
						end
					end
					return
				end
			end
		end
	end
	-- Manual mode: Check cursor position
	local handled = false
	for _, expr in ipairs(expressions) do
		if (cursor_col >= expr.start and cursor_col <= expr.finish) or (mode == "i" and cursor_col == expr.closing) then
			if expr.content:find("=") then
				vim.notify("Expression already calculated", vim.log.levels.INFO)
				return
			end
			local expression = expr.content:gsub("x", "*"):gsub("÷", "/")
			local success, result = pcall(function()
				return load("return " .. expression)()
			end)
			if success then
				local replacement = string.format("%s=%s", expression, result)
				local new_line = line:sub(1, expr.start - 1) .. replacement .. line:sub(expr.finish + 1)
				vim.api.nvim_set_current_line(new_line)
			else
				vim.notify("Invalid expression: " .. expression, vim.log.levels.ERROR)
			end
			handled = true
			return
		end
	end
	-- Handle incomplete backtick pairs in insert mode
	if not handled and (mode == "i" or not auto_trigger) then
		-- Find last opening backtick before cursor
		local open_pos = line:sub(1, cursor_col):find("`[^`]*$")
		if open_pos then
			local content = line:sub(open_pos + 1, cursor_col - 1)
			local pattern = auto_trigger and "^;%s*[%d%+%-%*%/%%%s%.%(%)x÷]+$" or "^[%d%+%-%*%/%%%s%.%(%)x÷]+$"
			if not content:find("=") and content:match(pattern) then
				local expr_to_eval = content:gsub("x", "*"):gsub("÷", "/")
				if auto_trigger then
					expr_to_eval = expr_to_eval:sub(2) -- Remove leading ';' for auto
				end
				local success, result = pcall(function()
					return load("return " .. expr_to_eval)()
				end)
				if success then
					local cleaned = expr_to_eval:gsub("^%s*", "")
					local replacement = string.format("`%s=%s`", cleaned, result)
					local new_line = line:sub(1, open_pos - 1) .. replacement .. line:sub(cursor_col)
					vim.api.nvim_set_current_line(new_line)
					-- Move cursor to end of replacement
					vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), open_pos + #replacement - 1 })
				else
					vim.notify("Invalid expression: " .. content, vim.log.levels.ERROR)
				end
				return
			end
		end
	end
	if not auto_trigger then
		vim.notify("No expression under cursor", vim.log.levels.WARN)
	end
end

-- Markdown inline calculator (works not only in markdown) lamw26wmal
--
-- In INSERT mode if you type `20+20 (NOTICE THAT YOU DON'T NEED TO TYPE THE
-- LAST BACKTICK) and then run the keymap, you get `20+20=40`
--
-- In NORMAL mode if you have `20+20` and run the keymap inside the backticks
-- you get `20+20=40`
--
-- Automatic mode (disabled by default) works if you include a ; so for example
-- If you type `;20+20` when you type the final ` turns into `20+20=40`
vim.keymap.set({ "n", "i" }, "<M-3>", function()
	md_inline_calculator(false) -- Explicit manual trigger
end, { desc = "[P]Inline calculator" })

-- -- This autocmd allows you to use the ; to automatically calculate
-- -- For example `;3*3` is turned into `3*3=9` when you type the last backtic
-- -- WARNING: This autocmd uses TextChangedI which triggers on EVERY insert-mode
-- -- keystroke, which could probably cause performance issues, so use at your
-- -- own risk
--
-- -- INFO: If you want the autocmdn to work, and you use mini.pairs, you'll
-- -- probably want to disable it for the back tick
-- -- ~/github/dotfiles-latest/neovim/neobean/lua/plugins/mini-pairs.lua
--
-- -- Perform calculation when closing a backtick pair (`...`)
-- -- 10ms delay ensures buffer stability
-- vim.api.nvim_create_autocmd("TextChangedI", {
--   pattern = "*",
--   callback = function()
--     local col = vim.api.nvim_win_get_cursor(0)[2] -- Get 0-based column
--     if vim.api.nvim_get_current_line():sub(col, col) == "`" then
--       vim.defer_fn(function()
--         md_inline_calculator(true)
--       end, 10)
--     end
-- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/config/keymaps.lua
-- ~/github/dotfiles-latest/neovim/neobean/lua/config/keymaps.lua
