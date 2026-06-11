-- media.lua
-- 対応アプリ: Spotify / Apple Music / Google Chrome / Safari / Firefox / Arc / Brave / Opera
-- 機能:
--   - アートワーク縮小表示 (通常時)
--   - マウスホバーでアートワーク拡大
--   - ホバー時にタイトル・アーティスト表示
--   - ポップアップで再生コントロール (前/再生停止/次)
--   - アプリアイコンをラベル左に表示

local icons = require("icons")
local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 対応ホワイトリスト
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local whitelist = {
	["Spotify"] = true,
	["Music"] = true,
	["Google Chrome"] = true,
	["Safari"] = true,
	["Firefox"] = true,
	["Arc"] = true,
	["Brave Browser"] = true,
	["Opera"] = true,
	["Chromium"] = true,
}

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- アートワーク (メインアイテム)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local COVER_SCALE_NORMAL = 0.70
local COVER_SCALE_HOVER = 0.95

local media_cover = sbar.add("item", "media.cover", {
	position = "right",
	drawing = false,
	updates = true,
	padding_left = 4,
	padding_right = 4,
	background = {
		image = {
			string = "media.artwork",
			scale = COVER_SCALE_NORMAL,
		},
		color = colors.transparent,
	},
	label = { drawing = false },
	icon = { drawing = false },
	popup = {
		align = "center",
		horizontal = true,
		height = 30,
	},
})

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- アプリアイコン
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local media_app = sbar.add("item", "media.app", {
	position = "right",
	drawing = false,
	padding_left = 0,
	padding_right = 0,
	width = 0,
	label = { drawing = false },
	icon = {
		font = { family = settings.font.text, size = 13.0 },
		color = colors.white,
		y_offset = 0,
	},
})

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- アーティスト名 (上段)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local media_artist = sbar.add("item", "media.artist", {
	position = "right",
	drawing = false,
	padding_left = 3,
	padding_right = 0,
	width = 0,
	icon = { drawing = false },
	label = {
		width = 0,
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Regular"],
			size = 9.0,
		},
		color = colors.with_alpha(colors.white, 0.6),
		max_chars = 20,
		y_offset = 6,
	},
})

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 曲タイトル (下段)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local media_title = sbar.add("item", "media.title", {
	position = "right",
	drawing = false,
	padding_left = 3,
	padding_right = 4,
	icon = { drawing = false },
	label = {
		width = 0,
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Semibold"],
			size = 11.0,
		},
		color = colors.white,
		max_chars = 18,
		y_offset = -5,
	},
})

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- ポップアップ: 再生コントロール
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
sbar.add("item", "media.popup.back", {
	position = "popup." .. media_cover.name,
	icon = { string = icons.media.back },
	label = { drawing = false },
	click_script = "nowplaying-cli previous",
})

sbar.add("item", "media.popup.play", {
	position = "popup." .. media_cover.name,
	icon = { string = icons.media.play_pause },
	label = { drawing = false },
	click_script = "nowplaying-cli togglePlayPause",
})

sbar.add("item", "media.popup.next", {
	position = "popup." .. media_cover.name,
	icon = { string = icons.media.forward },
	label = { drawing = false },
	click_script = "nowplaying-cli next",
})

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- テキスト幅アニメーション
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local interrupt = 0

local function animate_detail(detail)
	if not detail then
		interrupt = interrupt - 1
	end
	if interrupt > 0 and not detail then
		return
	end

	sbar.animate("tanh", 30, function()
		local w = detail and "dynamic" or 0
		media_artist:set({ label = { width = w } })
		media_title:set({ label = { width = w } })
		media_app:set({ drawing = detail })
	end)
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- media_change イベント
-- INFO のフィールドは文字列キーで安全にアクセスする
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
media_cover:subscribe("media_change", function(env)
	local info = env.INFO
	if type(info) ~= "table" then
		return
	end

	-- フィールドを文字列キーで安全に取得
	local app = tostring(info["app"] or "")
	local state = tostring(info["state"] or "")
	local artist = tostring(info["artist"] or "")
	local title = tostring(info["title"] or "")

	-- デバッグ用 (動作確認後コメントアウト可)
	print("[media] app=" .. app .. " state=" .. state .. " title=" .. title)

	-- ホワイトリスト外は無視
	if not whitelist[app] then
		return
	end

	local playing = (state == "playing")

	if playing then
		local app_icon = app_icons[app] or "󰎈"

		media_app:set({ icon = { string = app_icon } })
		media_artist:set({ drawing = true, label = { string = artist } })
		media_title:set({ drawing = true, label = { string = title } })
		media_cover:set({ drawing = true })

		animate_detail(true)
		interrupt = interrupt + 1
		sbar.delay(5, function()
			animate_detail(false)
		end)
	else
		media_cover:set({ drawing = false, popup = { drawing = false } })
		media_artist:set({ drawing = false })
		media_title:set({ drawing = false })
		media_app:set({ drawing = false })
		interrupt = 0
	end
end)

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- マウスホバー: アートワーク拡大 + テキスト展開
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
media_cover:subscribe("mouse.entered", function(_)
	sbar.animate("tanh", 15, function()
		media_cover:set({
			background = { image = { scale = COVER_SCALE_HOVER } },
		})
	end)
	interrupt = interrupt + 1
	animate_detail(true)
end)

media_cover:subscribe("mouse.exited", function(_)
	sbar.animate("tanh", 15, function()
		media_cover:set({
			background = { image = { scale = COVER_SCALE_NORMAL } },
		})
	end)
	animate_detail(false)
end)

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- クリック: ポップアップトグル
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
media_cover:subscribe("mouse.clicked", function(_)
	local is_open = media_cover:query().popup.drawing
	media_cover:set({ popup = { drawing = not is_open } })
end)

-- ポップアップ外クリックで閉じる
media_title:subscribe("mouse.exited.global", function(_)
	media_cover:set({ popup = { drawing = false } })
end)
