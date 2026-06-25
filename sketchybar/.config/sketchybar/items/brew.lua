-- items/brew.lua (統合版 + brew.sh の色分けロジック移植)

local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- ------------------------------------------------------------------ --
--  Constants
-- ------------------------------------------------------------------ --
local CHECK_INTERVAL = 12 * 60 * 60 -- 12時間（秒）

-- ------------------------------------------------------------------ --
--  Internal State
-- ------------------------------------------------------------------ --
local state = {
	outdated = {},
	checking = false,
}

local brew -- 前方宣言

-- ------------------------------------------------------------------ --
--  Helper: カウント数に応じた色を返す（brew.sh のロジック移植）
--
--   30〜59件 → orange
--   10〜29件 → yellow
--    1〜 9件 → white
--        0件 → green
-- ------------------------------------------------------------------ --
local function count_color(count)
	if count >= 30 then
		return colors.orange
	elseif count >= 10 then
		return colors.yellow
	elseif count >= 1 then
		return colors.blue
	else
		return colors.green
	end
end

-- ------------------------------------------------------------------ --
--  Helper: バー表示の更新
-- ------------------------------------------------------------------ --
local function update_display()
	if not brew then
		return
	end

	if state.checking then
		brew:set({
			icon = { string = icons.brew, color = colors.grey },
			label = { string = "Checking…", color = colors.grey },
		})
		return
	end

	local count = #state.outdated
	local color = count_color(count)

	if count == 0 then
		brew:set({
			icon = { string = icons.package, color = color },
			label = { string = "✓ ", color = color },
		})
	else
		brew:set({
			icon = { string = icons.update, color = color },
			label = { string = count .. "  ", color = color },
		})
	end
end

-- ------------------------------------------------------------------ --
--  Widget: パッケージ行の追加
-- ------------------------------------------------------------------ --
local function add_package_item(name, current_ver, new_ver, index)
	sbar.add("item", "brew.widget.pkg." .. index, {
		position = "popup.brew",
		width = 280,
		align = "left",
		label = {
			string = name .. "  " .. current_ver .. " → " .. new_ver,
			font = { family = settings.font.text_round, size = 14 },
			color = colors.white,
			padding_right = 12,
		},
		icon = {
			string = icons.package,
			color = colors.green,
			padding_left = 10,
			padding_right = 6,
		},
		background = {
			color = colors.transparent,
			border_color = colors.transparent,
		},
		click_script = "",
	})
end

-- ------------------------------------------------------------------ --
--  Widget: パッケージリストの描画
-- ------------------------------------------------------------------ --
local function render_packages(packages)
	sbar.remove("/brew\\.widget\\.pkg\\..*/")

	if #packages == 0 then
		sbar.add("item", "brew.widget.pkg.1", {
			position = "popup.brew",
			width = 280,
			align = "center",
			label = {
				string = "All up to date ✓",
				color = colors.green,
				font = { size = 14 },
			},
			icon = { drawing = false },
			background = {
				color = colors.popup.bg,
				border_color = colors.popup.border,
			},
		})
	else
		for i, pkg in ipairs(packages) do
			add_package_item(pkg.name, pkg.current, pkg.new, i)
		end
	end
end

-- ------------------------------------------------------------------ --
--  Widget: 静的ポップアップアイテム（brew 登録より前に定義する）
-- ------------------------------------------------------------------ --

-- ヘッダー
sbar.add("item", "brew.widget.header", {
	position = "popup.brew",
	width = 280,
	align = "center",
	label = {
		string = "Brew Updates",
		font = {
			family = settings.font.text_round,
			style = settings.font.style_map["Semibold"],
			size = 14,
		},
		color = colors.white,
	},
	icon = { drawing = false },
	background = {
		color = colors.bg2,
		border_color = colors.transparent,
		-- height = 28,
	},
	padding_left = 0,
	padding_right = 0,
})

-- セパレーター
sbar.add("item", "brew.widget.sep", {
	position = "popup.brew",
	width = 280,
	background = {
		color = colors.transparent,
		-- height = 1,
		border_color = colors.transparent,
	},
	icon = { drawing = false },
	label = { drawing = false },
})

-- "Update All" ボタン
sbar.add("item", "brew.widget.update_all", {
	position = "popup.brew",
	width = 280,
	align = "center",
	label = {
		string = "  Update All",
		font = {
			family = settings.font.text_round,
			style = settings.font.style_map["Semibold"],
			size = 14,
		},
		color = colors.black,
	},
	icon = {
		string = icons.update,
		color = colors.black,
		padding_right = 6,
	},
	background = {
		color = colors.green,
		border_color = colors.transparent,
		corner_radius = 6,
		height = 28,
	},
	padding_left = 8,
	padding_right = 8,
	click_script = "brew upgrade && sketchybar --trigger brew_update",
})

-- ------------------------------------------------------------------ --
--  brew outdated の非同期取得
-- ------------------------------------------------------------------ --
local function fetch_outdated(force)
	if state.checking and not force then
		return
	end -- force時はスキップしない
	-- if state.checking then
	-- 	return
	-- end

	state.checking = true
	update_display()

	-- HOMEBREW_DOWNLOAD_CONCURRENCY=1 : brew.sh と同様の CPU 検出クラッシュ回避
	local cmd = 'export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"'
		.. " HOMEBREW_DOWNLOAD_CONCURRENCY=1;"
		.. ' /bin/zsh -c "brew outdated --json" 2>&1'

	sbar.exec(cmd, function(output)
		state.checking = false
		local log = io.open("/tmp/sketchybar_brew_debug.log", "w")
		if log then
			log:write("=== raw output ===\n" .. (output or "nil") .. "\n\n=== parsed ===\n")
		end

		state.outdated = {}

		local is_error = not output or output:match("Error:") or not output:match("%[")

		if not is_error and output ~= "" then
			for pkg_json in output:gmatch("{(.-)}") do
				local name = pkg_json:match('"name"%s*:%s*"([^"]+)"')
				local installed = pkg_json:match('"installed_versions"%s*:%s*%[%s*"([^"]+)"')
				local current = pkg_json:match('"current_version"%s*:%s*"([^"]+)"')
				if name and installed and current then
					table.insert(state.outdated, { name = name, current = installed, new = current })
					if log then
						log:write("  OK: " .. name .. " " .. installed .. " -> " .. current .. "\n")
					end
				end
			end
		end

		if log then
			log:write("\n=== total: " .. #state.outdated .. " ===\n")
			if is_error then
				log:write("STATUS: error\n")
			end
			log:close()
		end

		state.checking = false

		if is_error then
			brew:set({
				icon = { string = icons.brew or "", color = colors.red },
				label = { string = "Brew Error", color = colors.red },
			})
		else
			update_display()
		end

		render_packages(state.outdated)
	end)
end

-- ------------------------------------------------------------------ --
--  メインアイテムの登録
-- ------------------------------------------------------------------ --
brew = sbar.add("item", "brew", {
	position = "right",
	icon = {
		string = icons.brew,
		font = { family = settings.font.icons, size = 16 },
		color = colors.green,
		padding_left = 8,
		padding_right = 4,
	},

	label = {
		string = "…",
		font = { family = settings.font.text_round, size = 15 },
		color = colors.green,
		padding_right = 8,
	},

	background = {
		color = colors.transparent,
		border_color = colors.transparent,
		border_width = 0,
		corner_radius = 6,
		height = 26,
	},

	popup = {
		align = "right",
		font = { family = settings.font.text_round, size = 15 },
		background = {
			color = colors.popup.bg,
			border_color = colors.popup.border,
			border_width = 0,
			corner_radius = 8,
		},
		y_offset = 4,
	},

	update_freq = CHECK_INTERVAL,
})

-- ------------------------------------------------------------------ --
--  イベント登録
-- ------------------------------------------------------------------ --
sbar.add("event", "brew_update")

-- ------------------------------------------------------------------ --
--  イベント購読
-- ------------------------------------------------------------------ --
local popup_open = false

-- クリック: popup 開閉 + 即時チェック
brew:subscribe("mouse.clicked", function(env)
	if popup_open then
		popup_open = false
		brew:set({ popup = { drawing = false } })
	else
		popup_open = true
		render_packages(state.outdated)
		brew:set({ popup = { drawing = true } })
		fetch_outdated(true)
	end
end)

-- popup 外クリックで閉じる
brew:subscribe("mouse.exited.global", function(env)
	if popup_open then
		popup_open = false
		brew:set({ popup = { drawing = false } })
	end
end)

-- 定期チェック（update_freq = CHECK_INTERVAL に対応）
brew:subscribe("routine", function(_)
	fetch_outdated(true)
end)

-- `brew upgrade` 完了後などの外部トリガー
brew:subscribe("brew_update", function(_)
	fetch_outdated(true)
end)

-- システムスリープ復帰後
brew:subscribe("system_woke", function(_)
	fetch_outdated(true)
end)

-- 起動時の初回チェック
fetch_outdated(true) -- items/brew.lua (統合版)
