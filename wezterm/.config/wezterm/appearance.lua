local wezterm = require("wezterm")
local module = {}

local appearance = {
	color_scheme = "Solarized Dark Higher Contrast",
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
	hide_tab_bar_if_only_one_tab = false,
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
		background = "#1a1a2e",

		-- 通常のタブバー透過設定（use_fancy_tab_bar = false用）
		tab_bar = {
			background = "none",
			inactive_tab_edge = "none",
		},

		-- カーソルと選択色
		cursor_bg = "#80EBDF",
		cursor_fg = "#000000",
		cursor_border = "#80EBDF",
		selection_bg = "#ffdd00",
		selection_fg = "#000000",
	},
}

function module.apply_to_config(config)
	for k, v in pairs(appearance) do
		config[k] = v
	end
end

return module
