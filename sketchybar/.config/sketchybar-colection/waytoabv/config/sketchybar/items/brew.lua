-- items/brew.lua
-- メインの Brew アイテム
--   ・バーにアイコン＋件数を表示
--   ・クリックでポップアップ表示 & brew upgrade 実行
--   ・12 時間ごとに自動で outdated チェック

local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local brew_widget = require("items.widgets.brew") -- ウィジェット側

-- ------------------------------------------------------------------ --
--  定数
-- ------------------------------------------------------------------ --
local CHECK_INTERVAL = 12 * 60 * 60 -- 12 時間（秒）

-- ------------------------------------------------------------------ --
--  内部状態
-- ------------------------------------------------------------------ --
local state = {
	outdated = {}, -- { {name, current, new}, ... }
	checking = false,
}

-- brew アイテムへの参照（モジュールレベルで保持し、クロージャ問題を回避）
local brew

-- ------------------------------------------------------------------ --
--  ヘルパー：バーの表示を更新
--  モジュールレベルの brew を直接参照するため引数なし
-- ------------------------------------------------------------------ --
local function update_display()
	-- まだ brew オブジェクトが登録されていなければスキップ
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
--  brew outdated を非同期で実行してパースする
-- ------------------------------------------------------------------ --
local function fetch_outdated()
	state.checking = true
	update_display()

	-- 1. 環境変数のPATHにHomebrewのパスを明示的に追加して実行する
	local wrapped_cmd = '/bin/zsh -c "brew outdated --json" 2>&1'

	sbar.exec(wrapped_cmd, function(output)
		local log = io.open("/tmp/sketchybar_brew_debug.log", "w")
		if log then
			log:write("=== raw output ===\n")
			log:write((output or "nil") .. "\n")
			log:write("\n=== parsed packages ===\n")
		end

		-- タイポを確実に修正 (outdeted -> outdated)
		state.outdated = {}

		-- output が空、または nil の場合は解析をスキップ
		if output and output ~= "" then
			-- 2. 頑丈な2ステップパース処理
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
			log:close()
		end

		-- 3. 状態を戻して描画をキック
		state.checking = false
		update_display()
		brew_widget.render(state.outdated)
	end)
end
-- ------------------------------------------------------------------ --
--  アイテム本体を登録
-- ------------------------------------------------------------------ --
brew = sbar.add("item", "brew", {
	position = "right",

	icon = {
		string = icons.brew,
		font = {
			family = settings.font.icons,
			size = 16,
		},
		color = colors.white,
		padding_left = 8,
		padding_right = 4,
	},

	label = {
		string = "…",
		font = {
			family = settings.font.text,
			size = 13,
		},
		color = colors.white,
		padding_right = 8,
	},

	background = {
		color = colors.bg1,
		border_color = colors.border,
		border_width = 1,
		corner_radius = 6,
		height = 26,
	},

	-- ポップアップの設定
	popup = {
		align = "right",
		background = {
			color = colors.bg1,
			border_color = colors.border,
			border_width = 1,
			corner_radius = 8,
		},
		y_offset = 4,
	},

	-- 12 時間ごとに自動チェック用のトリガー
	update_freq = CHECK_INTERVAL,
	script = "~/.config/sketchybar/items/brew.lua", -- 自身を再実行
})

-- ポップアップの開閉状態を Lua 側で管理
local popup_open = false

-- ------------------------------------------------------------------ --
--  クリック：ポップアップ開閉 & 更新実行
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

-- ポップアップ外クリックで閉じる
brew:subscribe("mouse.exited.global", function(env)
	if popup_open then
		popup_open = false
		brew:set({ popup = { drawing = false } })
	end
end)

-- 定期実行（update_freq が発火したとき）
brew:subscribe("routine", function(_)
	fetch_outdated()
end)

-- 外部トリガー "brew_update"（brew upgrade 完了後などに発火）
brew:subscribe("brew_update", function(_)
	fetch_outdated()
end)

-- 起動時に即チェック
brew:subscribe("system_woke", function(_)
	fetch_outdated()
end)

fetch_outdated() -- 初回チェック
