local colors = require("colors")
local settings = require("settings")
local backend = require("items.spaces_aerospace")

local MAX_WS = 10 -- 管理するワークスペースの最大数
local MAX_APPS = 12 -- 1ワークスペースあたりの最大アプリアイコン数

---@class WsSlot
---@field num     SbarItem
---@field apps    SbarItem[]
---@field bracket SbarItem

---@type WsSlot[]
local slots = {} -- 事前生成したスロットのテーブル { [ws番号] = WsSlot }

-- ワークスペース番号アイテムの名前を返す
-- @param i number ワークスペース番号
local function name_num(i)
	return "aerospace.ws." .. i .. ".num"
end

-- アプリアイコンアイテムの名前を返す
-- @param i number ワークスペース番号
-- @param j number アイコンのインデックス（1〜MAX_APPS）
local function name_app(i, j)
	return "aerospace.ws." .. i .. ".app." .. j
end

-- bracketアイテムの名前を返す
-- @param i number ワークスペース番号
local function name_brk(i)
	return "aerospace.ws." .. i .. ".bracket"
end

-- 文字列の前後の空白を除去して返す
-- @param s string トリム対象の文字列
-- @return string トリム済み文字列
local function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- ワークスペース番号を表示する sketchybar アイテムを生成して返す
-- 左クリックで該当ワークスペースに切り替える
-- 右クリックは何もしない（AeroSpace にはWS作成APIがないため）
-- @param i number ワークスペース番号
-- @return SbarItem 生成したアイテム
local function make_num(i)
	local item = sbar.add("item", name_num(i), {
		position = "left", -- bar の左ゾーンに配置（他ゾーンと混在しないよう明示）
		drawing = false,
		icon = {
			string = tostring(i),
			font = {
				family = settings.font.text_round,
				style = settings.font.style_map["Bold"],
				size = 12.0,
			},
			color = colors.grey,
			highlight_color = colors.white,
			padding_left = 4,
			padding_right = 4,
			y_offset = 1,
		},
		label = { drawing = false },
	})
	item:subscribe("mouse.clicked", function(env)
		if env.BUTTON == "left" then
			sbar.exec(backend.click_cmd(tostring(i)))
		end
	end)
	return item
end

-- アプリアイコンを表示する sketchybar アイテムを生成して返す
-- 初期状態は非表示（drawing = false）
-- @param i number ワークスペース番号
-- @param j number スロット内のアイコンインデックス（1〜MAX_APPS）
-- @return SbarItem 生成したアイテム
local function make_app(i, j)
	return sbar.add("item", name_app(i, j), {
		position = "left", -- bar の左ゾーンに配置（num と同ゾーンで連続させる）
		drawing = false,
		-- icon = {
		-- 	drwing = true,
		-- 	font = "sketchybar-app-font:Regular:16.0",
		-- 	color = colors.grey,
		-- 	padding_left = 2,
		-- 	padding_right = 2,
		-- },
		icon = { drawing = false },
		label = {
			drawing = false,
		},
		padding_left = 2,
		padding_right = 2,
		background = {
			drawing = true,
			image = { scale = 0.80, clip = 0.8 },
		},
	})
end

-- num・apps を囲む背景カプセル（bracket）を生成して返す
-- アクティブなWSのみ背景を表示する
-- @param i       number   ワークスペース番号
-- @param members string[] bracket に含めるアイテム名のリスト
-- @return SbarItem 生成した bracket アイテム
local function make_bracket(i, members)
	return sbar.add("bracket", name_brk(i), members, {
		blur_radius = 12,
		background = {
			drawing = false,
			color = colors.bg5,
			border_color = colors.bg1,
			blur_radius = 32,
			border_width = 1,
			height = 32,
			corner_radius = 10,
		},
	})
end

-- MAX_WS 分のスロット（num + apps + bracket）を事前に生成して slots に格納する
-- 起動時に一括生成することでちらつきを防ぐ
-- 表示/非表示は後から paint_slot / hide_slot で切り替える
local function build_pool()
	for i = 1, MAX_WS do
		local num = make_num(i)
		local apps = {}
		local members = { num.name }
		for j = 1, MAX_APPS do
			apps[j] = make_app(i, j)
			members[#members + 1] = apps[j].name
		end
		local bracket = make_bracket(i, members)
		slots[i] = { num = num, apps = apps, bracket = bracket }
	end
end

-- 指定スロットにワークスペースの状態を反映して表示する
-- アクティブ時は番号を白・アイコンを等倍・背景を表示
-- 非アクティブ時は番号をグレー・アイコンを縮小・背景を非表示
-- @param i      number   ワークスペース番号（slots のキー）
-- @param apps   string[] アプリ名のリスト（アイコン画像の参照に使用）
-- @param active boolean  フォーカス中かどうか
local function paint_slot(i, apps, active)
	local slot = slots[i]
	if not slot then
		return
	end

	slot.num:set({
		drawing = true,
		icon = { color = active and colors.white or colors.grey },
	})

	for j = 1, MAX_APPS do
		local app = apps[j]
		local item = slot.apps[j]
		if app then
			item:set({
				drawing = true,
				background = {
					drawing = true,
					blur_radius = 12,
					image = {
						string = "app." .. app,
						scale = active and 1.0 or 0.80,
						clip = 0.8,
					},
					x_offset = -1,
				},
			})
		else
			item:set({ drawing = false })
		end
	end
	slot.bracket:set({ background = { drawing = active } })
end

-- 指定スロットの全アイテムを非表示にする
-- 使われていないワークスペース番号のスロットに使用する
-- @param i number ワークスペース番号（slots のキー）
local function hide_slot(i)
	local slot = slots[i]
	if not slot then
		return
	end
	slot.num:set({ drawing = false })
	for j = 1, MAX_APPS do
		slot.apps[j]:set({ drawing = false })
	end
	slot.bracket:set({ background = { drawing = false } })
end

-- AeroSpace の状態を非同期取得してレイアウトテーブルを組み立て、callback に渡す
-- 全WS一覧を先に取得してからウィンドウ情報を取得することで
-- アプリのないWSも含めて全WSを表示できる
-- callback に渡す layout の構造:
--   { [ws番号(数値)] = { apps = {アプリ名, ...}, has_focus = bool } }
-- @param callback function(layout) 取得完了時に呼ばれる関数
local function fetch_layout(callback)
	-- Step1: 全WS一覧を取得（アプリなしのWSも漏れなく把握するため）
	sbar.exec(backend.list_workspaces_cmd(), function(ws_out)
		local all_ws = {}
		for line in ws_out:gmatch("[^\n]+") do
			local ws_id = trim(line)
			if ws_id ~= "" then
				all_ws[ws_id] = true -- 存在するWS IDをセットとして保持
			end
		end

		-- Step2: 全ウィンドウ一覧とフォーカス中WSを取得
		sbar.exec(backend.fetch_state_cmd(), function(output)
			local workspace_apps = {}
			local focused = ""
			local parsing_windows = true

			-- Step2a: 全WSを空エントリで初期化
			-- これによりアプリのないWSも layout に含まれる
			for ws_id, _ in pairs(all_ws) do
				workspace_apps[ws_id] = {}
			end

			-- Step2b: "ws_id|app_name" 行をパースしてアプリを追加
			for line in output:gmatch("[^\n]+") do
				if line == "---" then
					parsing_windows = false
				elseif parsing_windows then
					local ws, app = line:match("^(.-)|(.+)$")
					if ws and app then
						ws = trim(ws)
						app = trim(app)
						if ws ~= "" and app ~= "" then
							if not workspace_apps[ws] then
								workspace_apps[ws] = {}
							end
							local list = workspace_apps[ws]
							-- MAX_APPS を超えるアプリは切り捨て
							if #list < MAX_APPS then
								list[#list + 1] = app
							end
						end
					end
				else
					-- "---" 以降の行はフォーカス中 WS ID
					focused = trim(line)
				end
			end

			-- Step2c: ws_id（文字列）→ スロット番号（数値）に変換して layout を構築
			local layout = {}
			for ws_id, apps in pairs(workspace_apps) do
				local idx = tonumber(ws_id)
				if idx then
					layout[idx] = { apps = apps, has_focus = (ws_id == focused) }
				end
			end

			-- フォーカス中WSが list_workspaces に含まれていない場合の保険
			local focused_idx = tonumber(focused)
			if focused_idx and not layout[focused_idx] then
				layout[focused_idx] = { apps = {}, has_focus = true }
			end

			callback(layout)
		end)
	end)
end

-- AeroSpace の状態を取得して全スロットの表示を更新する
-- fetch_layout で状態取得 → circ アニメーションで全スロットを一括更新
local function refresh()
	fetch_layout(function(layout)
		sbar.animate("circ", 30, function()
			for i = 1, MAX_WS do
				local s = layout[i]
				if s then
					paint_slot(i, s.apps, s.has_focus)
				else
					hide_slot(i)
				end
			end
		end)
	end)
end

-- 起動処理
-- 0.5秒の遅延後に build_pool → イベント購読 → 初回 refresh を実行する
-- 遅延はsketchybar の初期化完了を待つため
sbar.delay(0.5, function()
	build_pool()

	-- イベント購読用の不可視ウォッチャーアイテム
	local watcher = sbar.add("item", "aerospace.watcher", {
		drawing = false,
		updates = true,
		padding_left = 0,
		padding_right = 0,
	})

	-- backend.events（aerospace_workspace_change, front_app_switched）に
	-- system_woke・forced を加えて購読する
	local subscribed_events = { "system_woke", "forced" }
	for _, ev in ipairs(backend.events) do
		subscribed_events[#subscribed_events + 1] = ev
	end
	watcher:subscribe(subscribed_events, function(_)
		refresh()
	end)

	-- 初回描画
	refresh()
end)
