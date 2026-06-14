local settings = require("settings")

local icons = {
	sf_symbols = {
		plus = "􀅼",
		loading = "􀖇",
		apple = "􀣺",
		gear = "􀍟",
		cpu = "􀫥",
		clipboard = "􀉄",
		calendar = "􀉉 ",

		switch = {
			on = "􁏮",
			off = "􁏯",
		},
		volume = {
			_100 = "􀊩",
			_66 = "􀊧",
			_33 = "􀊥",
			_10 = "􀊡",
			_0 = "􀊣",
		},
		battery = {
			_100 = "􀛨",
			_75 = "􀺸",
			_50 = "􀺶",
			_25 = "􀛩",
			_0 = "􀛪",
			charging = "􀢋",
		},
		wifi = {
			upload = "􀄨",
			download = "􀄩",
			connected = "􀙇",
			disconnected = "􀙈",
			router = "􁓤",
		},
		media = {
			back = "􀊎", -- SF Symbol: backward.end.fill
			play_pause = "􀊔", -- SF Symbol: playpause.fill
			forward = "􀊐", -- SF Symbol: forward.end.fill
		},
		-- icons.lua に追加
		brew = "󰿈", -- Nerd Fonts: mdi-beer (または好みのアイコン)
		package = "󰏗", -- mdi-package-variant
		update = "󰚰", -- mdi-update	-- media = {
		-- 	back = "􀊊",
		-- 	forward = "􀊌",
		-- 	play_pause = "􀊈",
		-- },
	},

	-- Alternative NerdFont icons
	nerdfont = {
		plus = "",
		loading = "",
		apple = "",
		gear = "",
		cpu = "",
		clipboard = "",
		calendar = "􀉉 ",

		switch = {
			on = "󱨥",
			off = "󱨦",
		},

		volume = {
			_100 = "",
			_66 = "",
			_33 = "",
			_10 = "",
			_0 = "",
		},
		battery = {
			_100 = "",
			_75 = "",
			_50 = "",
			_25 = "",
			_0 = "",
			charging = "󰂄",
		},
		wifi = {
			upload = "",
			download = "",
			connected = "󰖩",
			disconnected = "󰖪",
			router = "󱂇",
		},
		media = {
			back = "􀊎", -- SF Symbol: backward.end.fill
			play_pause = "􀊔", -- SF Symbol: playpause.fill
			forward = "􀊐", -- SF Symbol: forward.end.fill
		},
		-- icons.lua に追加
		brew = "󰿈", -- Nerd Fonts: mdi-beer (または好みのアイコン)
		package = "󰏗", -- mdi-package-variant
		update = "󰚰", -- mdi-update	-- media = {
		-- 	back = "",
		-- 	forward = "",
		-- 	play_pause = "",
		-- },
	},
}

if not (settings.icons == "NerdFont") then
	return icons.sf_symbols
else
	return icons.nerdfont
end
