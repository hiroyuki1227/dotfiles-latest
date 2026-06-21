local wezterm = require("wezterm")
-- Load the colors from my existing neobean colors.lua file
-- local colors = dofile(os.getenv("HOME") .. "/.config/wezterm/colors.lua")

local module = {}

-- Returns color scheme dependant on operating system theme setting (dark/light)
-- local function get_appearance()
-- 	if wezterm.gui then
-- 		return wezterm.gui.get_appearance()
-- 	end
-- 	return "Dark"
-- end
--
-- local function color_scheme_for_appearance(appearance)
-- 	if appearance:find("Dark") then
-- return "Solarized Dark - Patched"
-- return "Builtin Solarized Dark"
-- return "Tokyo Night"
-- return "eldritch"
-- return "tokyonight_night"
-- return "Solarized Dark Higher Contrast"
-- else
-- color_scheme_dir = { "~/.config/wezterm/themes" }
-- return "Solarized Dark - Patched"
-- return "Builtin Solarized Light"
-- return "Solarized Dark Higher Contrast"
-- return "eldritch"
-- return "tokyonight_day"
-- return "Solarized Osaka light"
-- end
-- return "Solarized Osaka"
-- end

-- local function get_color_sceheme_dir()
-- 	return { "~/.config/wezterm/themes/" }
-- end

local appearance = {
	-- color_scheme_dirs = get_color_sceheme_dir(),
	-- color_scheme = color_scheme_for_appearance(get_appearance()),
	-- color_scheme = "Solarized Dark Higher Contrast",
	-- color_scheme = "Solarized Dark",
	-- window title
	window_decorations = "RESIZE",
	window_close_confirmation = "NeverPrompt",

	-- Pane - 非アクティブPaneを暗くする
	inactive_pane_hsb = {
		hue = 1.0, -- 色相変更なし
		saturation = 0.5, -- 彩度を少し下げる
		brightness = 0.6, -- 明るさを40%下げて暗くする
	},

	-- Tab
	show_tabs_in_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = false,
	show_new_tab_button_in_tab_bar = false,
	tab_max_width = 30,
	use_fancy_tab_bar = true,

	-- タブバー透過設定（fancy tab bar用）
	window_frame = {
		inactive_titlebar_bg = "none",
		active_titlebar_bg = "none",
	},

	colors = {
		-- The default text color
		foreground = "#d8ffd8",
		-- The default background color
		background = "#000000", -- colors["linkarzu_color10"],

		-- Overrides the cell background color when the current cell is occupied by the cursor
		cursor_bg = "#00cc4f", -- colors["linkarzu_color24"],
		-- Overrides the text color when the current cell is occupied by the cursor
		cursor_fg = "#000000", -- colors["linkarzu_color10"],
		-- Specifies the border color of the cursor when the cursor style is set to Block
		cursor_border = "#ff9d00", --colors["linkarzu_color02"],

		-- The foreground color of selected text
		selection_fg = "#d8ffd8", -- colors["linkarzu_color14"],
		-- The background color of selected text
		selection_bg = "#ffe680", -- colors["linkarzu_color16"],

		-- The color of the scrollbar "thumb"; the portion that represents the current viewport
		scrollbar_thumb = "#000000", -- colors["linkarzu_color10"],

		-- The color of the split lines between panes
		split = "#ff9d00", -- colors["linkarzu_color02"],

		-- ANSI color palette
		ansi = {
			"#000000", -- colors["linkarzu_color10"], -- black
			"#c96d00", -- colors["linkarzu_color11"], -- red
			"#ff9d00", -- colors["linkarzu_color02"], -- green
			"#98ff98", -- colors["linkarzu_color05"], -- yellow
			"#00365c", -- colors["linkarzu_color04"], -- blue
			"#ffc94a", -- colors["linkarzu_color01"], -- magenta
			"#66ff99", -- colors["linkarzu_color03"], -- cyan
			"#d8ffd8", -- colors["linkarzu_color14"], -- white
		},

		-- Bright ANSI color palette
		brights = {
			"#ffe07a", -- colors["linkarzu_color08"], -- bright black
			"#c96d00", -- colors["linkarzu_color11"], -- bright red
			"#ff9d00", -- colors["linkarzu_color02"], -- bright green
			"#98ff98", -- colors["linkarzu_color05"], -- bright yellow
			"#00e65c", -- colors["linkarzu_color04"], -- bright blue
			"#ffc94a", -- colors["linkarzu_color01"], -- bright magenta
			"#66ff99", -- colors["linkarzu_color03"], -- bright cyan
			"#d8ffd8", -- colors["linkarzu_color14"], -- bright white
		},
		-- background = "#1a1a2e",

		-- 通常のタブバー透過設定（use_fancy_tab_bar = false用）
		tab_bar = {
			background = "none",
			inactive_tab_edge = "none",
		},
	},
}

function module.apply_to_config(config)
	for k, v in pairs(appearance) do
		config[k] = v
	end
end

return module
