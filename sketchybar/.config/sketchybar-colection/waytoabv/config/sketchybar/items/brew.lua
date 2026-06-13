-- items/brew.lua
-- Main Brew Item
--   - Displays icon + count in the bar
--   - Clicking toggles popup & executes brew upgrade
--   - Automatically checks for outdated packages every 12 hours

local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local brew_widget = require("items.widgets.brew") -- Widget side

-- ------------------------------------------------------------------ --
--  Constants
-- ------------------------------------------------------------------ --
local CHECK_INTERVAL = 12 * 60 * 60 -- 12 hours (seconds)

-- ------------------------------------------------------------------ --
--  Internal State
-- ------------------------------------------------------------------ --
local state = {
	outdated = {}, -- { {name, current, new}, ... }
	checking = false,
}

-- Reference to the brew item (held at module level to avoid closure issues)
local brew

-- ------------------------------------------------------------------ --
--  Helper: Update the bar display
--  Directly references module-level 'brew', so no arguments needed
-- ------------------------------------------------------------------ --
local function update_display()
	-- Skip if the brew object is not registered yet
	if not brew then
		return
	end

	local count = #state.outdated

	if state.checking then
		brew:set({
			icon = { string = icons.brew, color = colors.grey },
			label = { string = "確認中…", color = colors.grey },
		})
		return
	end

	if count == 0 then
		brew:set({
			icon = { string = icons.package, color = colors.green },
			label = { string = "最新", color = colors.green },
		})
	else
		brew:set({
			icon = { string = icons.update, color = colors.yellow },
			label = { string = count .. " 件", color = colors.yellow },
		})
	end
end

-- ------------------------------------------------------------------ --
--  Asynchronously fetch and parse 'brew outdated'
-- ------------------------------------------------------------------ --
local function fetch_outdated()
	-- すでにチェック中の場合は、重複して実行しない（多重起動の防止）
	if state.checking then
		return
	end

	state.checking = true
	update_display()

	-- 【解決】無限ループを防ぐため -il を廃止。Homebrewに必要な最低限の環境変数だけを直接注入する。
	-- HOME, USER, PATH, SHELL を明示的に渡すことで、.zshrc を再読込させずにクラッシュを防ぎます。
	local wrapped_cmd = 'export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH";/bin/zsh -c brew outdated --json 2>&1'

	sbar.exec(wrapped_cmd, function(output)
		local log = io.open("/tmp/sketchybar_brew_debug.log", "w")
		if log then
			log:write("=== raw output ===\n")
			log:write((output or "nil") .. "\n")
			log:write("\n=== parsed packages ===\n")
		end

		state.outdated = {}

		local is_error = not output or output:match("Error:") or (not output:match("%["))

		if not is_error and output ~= "" then
			for package_json in output:gmatch("{(.-)}") do
				local name = package_json:match('"name"%s*:%s*"([^"]+)"')
				local installed = package_json:match('"installed_versions"%s*:%s*%[%s*"([^"]+)"')
				local current = package_json:match('"current_version"%s*:%s*"([^"]+)"')

				if name and installed and current then
					table.insert(state.outdated, {
						name = name,
						current = installed,
						new = current,
					})
					if log then
						log:write("  OK: " .. name .. " " .. installed .. " -> " .. current .. "\n")
					end
				end
			end
		end

		if log then
			log:write("\n=== total count: " .. #state.outdated .. " ===\n")
			if is_error then
				log:write("STATUS: Error detected. Handled safely.\n")
			end
			log:close()
		end

		state.checking = false

		if is_error then
			brew:set({
				icon = { string = icons.brew or "", color = colors.red },
				label = { string = "Brew Error", color = colors.red },
			})
		else
			update_display()
		end

		brew_widget.render(state.outdated)
	end)
end
-- ------------------------------------------------------------------ --
--  Register Main Item
-- ------------------------------------------------------------------ --
brew = sbar.add("item", "brew", {
	position = "right",

	icon = {
		string = icons.brew,
		font = {
			family = settings.font.icons,
			size = 16,
		},
		color = colors.green,
		padding_left = 8,
		padding_right = 4,
	},

	label = {
		string = "…",
		font = {
			family = settings.font.text,
			size = 15,
		},
		color = colors.green,
		padding_right = 8,
	},

	-- 【解決】border を完全に消す設定（透明化 + 幅を0に）
	background = {
		color = colors.transparent,
		border_color = colors.transparent,
		border_width = 0,
		corner_radius = 6,
		height = 26,
	},

	-- Popup Settings
	popup = {
		align = "right",
		font = {
			family = settings.font.text,
			size = 15,
		},
		background = {
			color = colors.popup.bg,
			border_color = colors.popup.border,
			border_width = 0,
			corner_radius = 8,
		},
		y_offset = 4,
	},

	-- 【解決】クラッシュ・無限ループの原因を削除
	update_freq = CHECK_INTERVAL,
})

-- Manage popup open/close state on the Lua side
local popup_open = false

-- ------------------------------------------------------------------ --
--  Click: Toggle popup & execute update
-- ------------------------------------------------------------------ --
brew:subscribe("mouse.clicked", function(env)
	if popup_open then
		popup_open = false
		brew:set({ popup = { drawing = false } })
	else
		popup_open = true
		brew_widget.render(state.outdated)
		brew:set({ popup = { drawing = true } })
		fetch_outdated()
	end
end)

-- Close popup when clicking outside
brew:subscribe("mouse.exited.global", function(env)
	if popup_open then
		popup_open = false
		brew:set({ popup = { drawing = false } })
	end
end)

-- Periodic execution (when update_freq triggers)
brew:subscribe("routine", function(_)
	fetch_outdated()
end)

-- External trigger "brew_update" (fired after brew upgrade completes, etc.)
brew:subscribe("brew_update", function(_)
	fetch_outdated()
end)

-- Check immediately on system wake
brew:subscribe("system_woke", function(_)
	fetch_outdated()
end)

fetch_outdated() -- Initial check
-- -- items/brew.lua
-- -- Main Brew Item
-- --   - Displays icon + count in the bar
-- --   - Clicking toggles popup & executes brew upgrade
-- --   - Automatically checks for outdated packages every 12 hours
--
-- local colors = require("colors")
-- local icons = require("icons")
-- local settings = require("settings")
-- local brew_widget = require("items.widgets.brew") -- Widget side
--
-- -- ------------------------------------------------------------------ --
-- --  Constants
-- -- ------------------------------------------------------------------ --
-- local CHECK_INTERVAL = 12 * 60 * 60 -- 12 hours (seconds)
--
-- -- ------------------------------------------------------------------ --
-- --  Internal State
-- -- ------------------------------------------------------------------ --
-- local state = {
-- 	outdated = {}, -- { {name, current, new}, ... }
-- 	checking = false,
-- }
--
-- -- Reference to the brew item (held at module level to avoid closure issues)
-- local brew
--
-- -- ------------------------------------------------------------------ --
-- --  Helper: Update the bar display
-- --  Directly references module-level 'brew', so no arguments needed
-- -- ------------------------------------------------------------------ --
-- local function update_display()
-- 	-- Skip if the brew object is not registered yet
-- 	if not brew then
-- 		return
-- 	end
--
-- 	local count = #state.outdated
--
-- 	if state.checking then
-- 		brew:set({
-- 			icon = { string = icons.brew, color = colors.grey },
-- 			label = { string = "Checking…", color = colors.grey },
-- 		})
-- 		return
-- 	end
--
-- 	if count == 0 then
-- 		brew:set({
-- 			icon = { string = icons.package, color = colors.green },
-- 			label = { string = "Up to date", color = colors.green },
-- 		})
-- 	else
-- 		brew:set({
-- 			icon = { string = icons.update, color = colors.yellow },
-- 			label = { string = count .. " updates", color = colors.yellow },
-- 		})
-- 	end
-- end
--
-- -- ------------------------------------------------------------------ --
-- --  Asynchronously fetch and parse 'brew outdated'
-- -- ------------------------------------------------------------------ --
-- local function fetch_outdated()
-- 	state.checking = true
-- 	update_display()
--
-- 	-- 1. Explicitly add Homebrew path to PATH environment variable and execute
-- 	local wrapped_cmd = '/bin/zsh -c "brew outdated --verbose" 2>&1'
--
-- 	sbar.exec(wrapped_cmd, function(output)
-- 		local log = io.open("/tmp/sketchybar_brew_debug.log", "w")
-- 		if log then
-- 			log:write("=== raw output ===\n")
-- 			log:write((output or "nil") .. "\n")
-- 			log:write("\n=== parsed packages ===\n")
-- 		end
--
-- 		-- Ensure typo is fixed (outdeted -> outdated)
-- 		state.outdated = {}
--
-- 		-- Skip parsing if output is empty or nil
-- 		if output and output ~= "" then
-- 			-- 2. Robust 2-step parsing process
-- 			for package_json in output:gmatch("{(.-)}") do
-- 				local name = package_json:match('"name"%s*:%s*"([^"]+)"')
-- 				local installed = package_json:match('"installed_versions"%s*:%s*%[%s*"([^"]+)"')
-- 				local current = package_json:match('"current_version"%s*:%s*"([^"]+)"')
--
-- 				if name and installed and current then
-- 					table.insert(state.outdated, {
-- 						name = name,
-- 						current = installed,
-- 						new = current,
-- 					})
-- 					if log then
-- 						log:write("  OK: " .. name .. " " .. installed .. " -> " .. current .. "\n")
-- 					end
-- 				end
-- 			end
-- 		end
--
-- 		if log then
-- 			log:write("\n=== total count: " .. #state.outdated .. " ===\n")
-- 			log:close()
-- 		end
--
-- 		-- 3. Reset state and trigger rendering
-- 		state.checking = false
-- 		update_display()
-- 		brew_widget.render(state.outdated)
-- 	end)
-- end
-- -- ------------------------------------------------------------------ --
-- --  Register Main Item
-- -- ------------------------------------------------------------------ --
-- brew = sbar.add("item", "brew", {
-- 	position = "right",
--
-- 	icon = {
-- 		string = icons.brew,
-- 		font = {
-- 			family = settings.font.icons,
-- 			size = 16,
-- 		},
-- 		color = colors.green,
-- 		padding_left = 8,
-- 		padding_right = 4,
-- 	},
--
-- 	label = {
-- 		string = "…",
-- 		font = {
-- 			family = settings.font.text,
-- 			size = 15,
-- 		},
-- 		color = colors.green,
-- 		padding_right = 8,
-- 	},
--
-- 	background = {
-- 		color = colors.transparent,
-- 		border_color = colors.border,
-- 		border_width = 1,
-- 		corner_radius = 6,
-- 		height = 26,
-- 	},
--
-- 	-- Popup Settings
-- 	popup = {
-- 		align = "right",
-- 		font = {
-- 			family = settings.font.text,
-- 			size = 15,
-- 		},
-- 		background = {
-- 			color = colors.popup.bg,
-- 			border_color = colors.popup.border,
-- 			border_width = 1,
-- 			corner_radius = 8,
-- 		},
-- 		y_offset = 4,
-- 	},
--
-- 	-- Trigger for automatic check every 12 hours
-- 	update_freq = CHECK_INTERVAL,
-- 	script = "~/.config/sketchybar/items/brew.lua", -- Re-execute self
-- })
--
-- -- Manage popup open/close state on the Lua side
-- local popup_open = false
--
-- -- ------------------------------------------------------------------ --
-- --  Click: Toggle popup & execute update
-- -- ------------------------------------------------------------------ --
-- brew:subscribe("mouse.clicked", function(env)
-- 	if popup_open then
-- 		popup_open = false
-- 		brew:set({ popup = { drawing = false } })
-- 	else
-- 		popup_open = true
-- 		brew_widget.render(state.outdated)
-- 		brew:set({ popup = { drawing = true } })
-- 		fetch_outdated()
-- 	end
-- end)
--
-- -- Close popup when clicking outside
-- brew:subscribe("mouse.exited.global", function(env)
-- 	if popup_open then
-- 		popup_open = false
-- 		brew:set({ popup = { drawing = false } })
-- 	end
-- end)
--
-- -- Periodic execution (when update_freq triggers)
-- brew:subscribe("routine", function(_)
-- 	fetch_outdated()
-- end)
--
-- -- External trigger "brew_update" (fired after brew upgrade completes, etc.)
-- brew:subscribe("brew_update", function(_)
-- 	fetch_outdated()
-- end)
--
-- -- Check immediately on system wake
-- brew:subscribe("system_woke", function(_)
-- 	fetch_outdated()
-- end)
--
-- fetch_outdated() -- Initial check
