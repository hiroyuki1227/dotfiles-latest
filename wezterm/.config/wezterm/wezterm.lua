-- Pull in WezTerm API
local wezterm = require("wezterm")

-- Utility functions
local window_background_opacity = 0.8
local function toggle_window_background_opacity(window)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 1.0
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end
wezterm.on("toggle-window-background-opacity", toggle_window_background_opacity)

local function toggle_ligatures(window)
	local overrides = window:get_config_overrides() or {}
	if not overrides.harfbuzz_features then
		overrides.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
	else
		overrides.harfbuzz_features = nil
	end
	window:set_config_overrides(overrides)
end
wezterm.on("toggle-ligatures", toggle_ligatures)

-- Returns color scheme dependant on operating system theme setting (dark/light)
local function color_scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		-- return "Tokyo Night Moon"
		return "Solarized Dark Higher Contrast"
	else
		return "Solarized Dark Higher Contrast"
		-- return "Tokyo Night Day"
	end
end

-- Initialize actual config
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = color_scheme_for_appearance(wezterm.gui.get_appearance())

-- Start tmux when opening WezTerm
-- config.default_prog = { "/bin/zsh", "-l", "-c", "--", 'tmux new -As base' }

-- Skip closing confirmation when tmux is running
config.skip_close_confirmation_for_processes_named = { "tmux" }

-- Appearance
config.font = wezterm.font_with_fallback({
	{
		family = "SF Mono",
		weight = "Bold",
	},
	"UDEV Gothic NF",
	-- "JetBrainsMono Nerd Font",
})
config.font_size = 15.0
config.freetype_load_target = "Light"
-- config.freetype_render_target = 'HorizontalLcd'
-- ユニコードテキストの幅/表示を解釈するときに使用
-- 明示的な絵文字またはテキスト表示セレクターを尊重
config.unicode_version = 14
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt" -- AlwayPrompt or NeverPrompt
config.window_padding = {
	left = 15,
	right = 10,
	top = 15,
	bottom = 5,
}

-- アクティブなペインをわかりやすくするため、非アクティブパインをわずかに暗くする。
config.inactive_pane_hsb = {
	hue = 0.9, -- 色相を少しシフト（育みを抑える)
	saturation = 0.5,
	brightness = 1.0,
}

config.default_cursor_style = "SteadyBlock" -- BlinkingBlock SteadyUderline SteadyBar BlinkingBar SteadyBlock
-- Tab
config.show_tabs_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
-- config.show_close_tab_button_in_tabs = false -- Can only be used in nightly
config.tab_max_width = 30
config.use_fancy_tab_bar = true
-- use_fancy_tab_bar = trueの場合のタブバー透過設定
config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}
-- Hide borders between tabs
config.colors = {
	-- 青みがかった背景色（アクティブPaneで青く見える）
	background = "#1a1a2e",
	-- use_fancy_tab_bar = falseの場合のタブバー透過設定
	tab_bar = {
		background = "none",
		inactive_tab_edge = "none",
	},
	-- カーソルとコピーモード選択色（WezTermデフォルト）
	cursor_bg = "#80EBDF",
	cursor_fg = "#000000",
	cursor_border = "#80EBDF",
	selection_bg = "#ffdd00",
	selection_fg = "#000000",
}

config.window_background_opacity = window_background_opacity
config.macos_window_background_blur = 10
config.hide_tab_bar_if_only_one_tab = true
config.native_macos_fullscreen_mode = false
config.use_fancy_tab_bar = false
config.max_fps = 120
config.animation_fps = 120

config.audible_bell = "Disabled"
-- 日本語を入力するのに必要
config.use_ime = true
-- Alt key behavior
config.send_composed_key_when_left_alt_is_pressed = false -- Treat left Alt as Meta key (sends escape sequences)
config.send_composed_key_when_right_alt_is_pressed = true -- Keep right Alt for key composition
-- https://github.com/mtgto/macSKK?tab=readme-ov-file#q-wezterm-%E3%81%A7-c-j-%E3%82%92%E6%8A%BC%E3%81%99%E3%81%A8%E6%94%B9%E8%A1%8C%E3%81%95%E3%82%8C%E3%81%A6%E3%81%97%E3%81%BE%E3%81%84%E3%81%BE%E3%81%99
config.macos_forward_to_ime_modifier_mask = "SHIFT|CTRL"
-- QuickSelect patterns (SUPER + Space)
config.quick_select_patterns = {
	-- AWS ARN
	"\\barn:[\\w\\-]+:[\\w\\-]+:[\\w\\-]*:[0-9]*:[\\w\\-/:]+",
}

local keymaps = require("keymaps")
local functions = require("functions")
local workspace = require("workspace")
local hyprlinks = require("hyperlinks")
local tab = require("tab")
local statusbar = require("statusbar")

keymaps.apply_to_config(config)
functions.apply_to_config(config)
workspace.apply_to_config(config)
hyprlinks.apply_to_config(config)
tab.apply_to_config(config)
statusbar.apply_to_config(config)

require("modules.opacity").apply_to_config(config)

return config
