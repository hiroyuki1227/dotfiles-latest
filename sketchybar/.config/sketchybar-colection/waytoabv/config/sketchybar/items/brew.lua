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
			icon = { string = icons.brew, color = colors.green },
			label = { string = "最新", color = colors.green },
		})
	else
		brew:set({
			icon = { string = icons.brew, color = colors.yellow },
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

	local brew_cmd = "/opt/homebrew/bin/brew"

	-- --json でパース（--verbose は brew の内部バグでエラーになるため使わない）
	sbar.exec(brew_cmd .. " outdated --json 2>&1", function(output)
		local log = io.open("/tmp/sketchybar_brew_debug.log", "w")
		if log then
			log:write("=== raw output ===\n")
			log:write(output .. "\n")
			log:write("\n=== parsed packages ===\n")
		end

		state.outdated = {}

		-- formulae をパース: "name": "xxx" の次の installed_versions と current_version を取得
		for name, installed, current in
			output:gmatch(
				'"name":%s*"([^"]+)"[^{]-"installed_versions":%s*%[%s*"([^"]+)"[^%]]*%][^}]-"current_version":%s*"([^"]+)"'
			)
		do
			table.insert(state.outdated, {
				name = name,
				current = installed,
				new = current,
			})
			if log then
				log:write("  OK: " .. name .. " " .. installed .. " -> " .. current .. "\n")
			end
		end

		if log then
			log:write("\n=== total count: " .. #state.outdated .. " ===\n")
			log:close()
		end

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
	script = "$CONFIG_DIR/items/brew.lua", -- 自身を再実行
})

-- ポップアップの開閉状態を Lua 側で管理（POPUP_DRAWING 環境変数は不安定なため使わない）
local popup_open = false

-- ------------------------------------------------------------------ --
--  クリック：ポップアップ開閉 & 更新実行
-- ------------------------------------------------------------------ --
brew:subscribe("mouse.clicked", function(env)
	if popup_open then
		-- 閉じる
		popup_open = false
		brew:set({ popup = { drawing = false } })
	else
		-- 開く
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

-- ------------------------------------------------------------------ --
--  定期実行（update_freq が発火したとき）
-- ------------------------------------------------------------------ --
brew:subscribe("routine", function(_)
	fetch_outdated()
end)

-- ------------------------------------------------------------------ --
--  外部トリガー "brew_update"（brew upgrade 完了後などに発火）
-- ------------------------------------------------------------------ --
brew:subscribe("brew_update", function(_)
	fetch_outdated()
end)

-- ------------------------------------------------------------------ --
--  起動時に即チェック
-- ------------------------------------------------------------------ --
brew:subscribe("system_woke", function(_)
	fetch_outdated()
end)

fetch_outdated() -- 初回チェック
