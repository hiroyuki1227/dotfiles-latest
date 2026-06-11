-- brew.lua
-- Homebrew アップデート通知アイテム (SbarLua版)
-- 依存: colors, icons, settings は require で読み込む想定

local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
--
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- メインアイテムを追加
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local brew = sbar.add("item", "brew", {
	position = "right",
	icon = { string = icons.brew or "🍺" },
	label = { string = "…" },
	update_freq = 3600, -- 1時間ごとに routine イベントを受け取る
	popup = { align = "right" },
	script = "~/.config/sketchybar/items/brew.lua",
})

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- ポップアップ: ヘッダー
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local brew_header = sbar.add("item", "brew.details", {
	position = "popup." .. brew.name,
	label = {
		string = "Outdated Brews",
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = 14.0,
		},
		align = "left",
	},
	icon = { drawing = false },
	click_script = "sketchybar --set " .. brew.name .. " popup.drawing=off",
})

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- ポップアップ: パッケージ行をレンダリング
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- 現在のポップアップ行数を返すヘルパー
local function get_prev_count()
	local info = brew:query()
	if not info or not info.popup or not info.popup.items then
		return 0
	end
	local count = 0
	for _, name in ipairs(info.popup.items) do
		if name:match("^brew%.package%.") then
			count = count + 1
		end
	end
	return count
end

-- パッケージ行を描画/更新する
local function render_popup(outdated_lines, count, prev_count)
	-- 行が減った場合は古いアイテムを一括削除
	if count < prev_count then
		sbar.remove("/brew\\.package\\..*/")
	end

	for i, line in ipairs(outdated_lines) do
		local idx = i - 1 -- 0-indexed (元の COUNTER と同じ)

		if count > prev_count and i > prev_count then
			-- 新しく増えた行だけ add する
			sbar.add("item", "brew.package." .. idx, {
				position = "popup." .. brew.name,
			})
		end

		sbar.set("brew.package." .. idx, {
			label = {
				string = line,
				align = "right",
				padding_left = 20,
			},
			icon = { drawing = false },
			click_script = "sketchybar --set " .. brew.name .. " popup.drawing=off",
		})
	end
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- バーアイテム本体 (ラベル・色) を更新
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local function render_bar_item(count)
	local color, label

	if count >= 30 then
		color = colors.red
		label = tostring(count)
	elseif count >= 10 then
		color = colors.peach
		label = tostring(count)
	elseif count >= 3 then
		color = colors.yellow
		label = tostring(count)
	elseif count >= 1 then
		color = colors.text
		label = tostring(count)
	else
		color = colors.green
		label = "􀆅" -- チェックマーク (元スクリプトと同じ SF Symbol)
	end

	brew:set({
		label = { string = label },
		icon = { color = color },
	})
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- メイン更新ロジック
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local function update(sender)
	-- brew outdated を非同期実行 (スレッドをブロックしない)
	sbar.exec("brew outdated", function(outdated_output)
		-- 行に分割して空行を除去
		local lines = {}
		for line in (outdated_output .. "\n"):gmatch("([^\n]*)\n") do
			if line ~= "" then
				lines[#lines + 1] = line
			end
		end

		local count = #lines
		local prev_count = get_prev_count()

		render_bar_item(count)
		render_popup(lines, count, prev_count)

		-- 件数が変わったとき、または強制更新時にバウンスアニメーション
		if count ~= prev_count or sender == "forced" then
			sbar.animate("tanh", 15, function()
				brew:set({ label = { y_offset = 5 } })
				brew:set({ label = { y_offset = 0 } })
			end)
		end
	end)
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- イベント購読
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
brew:subscribe({ "routine", "forced" }, function(env)
	update(env.SENDER)
end)

brew:subscribe("mouse.entered", function(_)
	brew:set({ popup = { drawing = true } })
end)

brew:subscribe({ "mouse.exited", "mouse.exited.global" }, function(_)
	brew:set({ popup = { drawing = false } })
end)

brew:subscribe("mouse.clicked", function(_)
	local is_open = brew:query().popup.drawing
	brew:set({ popup = { drawing = not is_open } })
end)

-- -- Filename: ~/github/dotfiles-latest/sketchybar/felixkratz-linkarzu/plugins/brew.lua
--
-- local colors = require("colors")
--
-- -- brew outdated のカウントを取得
-- sbar.exec("brew outdated | wc -l | tr -d ' '", function(count_str)
-- 	local count = tonumber(count_str) or 0
--
-- 	local color = colors.red
-- 	local label = tostring(count)
--
-- 	if count == 0 then
-- 		color = colors.green
-- 		label = "􀆅"
-- 	elseif count <= 9 then
-- 		color = colors.white
-- 	elseif count <= 29 then
-- 		color = colors.yellow
-- 	elseif count <= 59 then
-- 		color = colors.orange
-- 	end
-- 	-- 60以上は red のまま
--
-- 	sbar.set("brew", {
-- 		label = { string = label },
-- 		icon = { color = color },
-- 	})
-- end)
