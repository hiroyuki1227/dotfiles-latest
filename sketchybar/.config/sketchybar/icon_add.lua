local M = {}

-- Material Design Icons & SF Symbols
M.CMD = "󰘳"
M.COG = "󰒓" -- system settings, system information, tinkertool
M.CHART = "󱕍" -- activity monitor, btop
M.LOCK = "󰌾"

M.SPACE = { "󰎤", "󰎧", "󰎪", "󰎭", "󰎱", "󰎳", "󰎶" }

M.APP = "󰣆" -- fallback app
M.TERM = "󰆍" -- fallback terminal app, terminal, warp, iterm2
M.PACKAGE = "󰏓" -- brew
M.DEV = "󰅨" -- nvim, neovide, xcode, vscode, intellij
M.FILE = "󰉋" -- ranger, finder
M.GIT = "󰊢" -- lazygit
M.CONTROLCENTER = "􀜊"

M.BLUETOOTH = "󰂯"
M.BLUETOOTH_OFF = "󰂲"
M.BACKLIGHT = "󰃟"
M.WEATHER = "󰖕" -- weather
M.MAIL = "󰇮" -- mail, outlook
M.CALC = "󰪚" -- calculator, numi
M.MAP = "󰆋" -- maps, find my
M.MICROPHONE = "󰍬" -- voice memos
M.CHAT = "󰍩" -- messages, slack, teams, discord, telegram
M.VIDEOCHAT = "󰍫" -- facetime, zoom, webex
M.NOTE = "󱞎" -- notes, textedit, stickies, word, bat
M.CAMERA = "󰄀" -- photo booth
M.WEB = "󰇧" -- safari, beam, duckduckgo, arc, edge, chrome, firefox
M.HOMEAUTOMATION = "󱉑" -- home
M.MUSIC = "􀑪"
M.PODCAST = "󰦔" -- podcasts
M.PLAY = "󱉺" -- tv, quicktime, vlc
M.BOOK = "󰂿" -- books
M.BOOKINFO = "󱁯" -- font book, dictionary
M.PREVIEW = "󰋲" -- screenshot, preview
M.PASSKEY = "󰷡" -- 1password
M.DOWNLOAD = "󱑢" -- progressive downloader, transmission
M.CAST = "󱒃" -- airflow
M.TABLE = "󰓫" -- excel
M.PRESENT = "󰈩" -- powerpoint
M.CLOUD = "󰅧" -- onedrive
M.PEN = "󰏬" -- curve
M.REMOTEDESKTOP = "󰢹" -- remote desktop, vmware, utm

M.CLOCK = "󰥔" -- clock, timewarrior, tty-clock
M.CALENDAR = "󰃭" -- calendar

M.WIFI = "󰖩"
M.WIFI_OFF = "󰖪"
M.VPN = "󰦝" -- vpn, nordvpn

-- Volume Icons
M.VOLUME = {
	_100 = "􀊩",
	_66 = "􀊧",
	_33 = "􀊥",
	_10 = "􀊡",
	_0 = "􀊣",
}

-- Battery Icons
M.BATTERY = {
	_100 = "􀛨",
	_75 = "􀺸",
	_50 = "􀺶",
	_25 = "􀛩",
	_0 = "􀛪",
	_CHARGING = "􀢋",
}

M.FIREFOX = "󰈹"

-- Git Icons
M.GIT_ISSUE = " charity" -- 􀍷
M.GIT_DISCUSSION = "􀒤"
M.GIT_PULL_REQUEST = "􀙡"
M.GIT_COMMIT = "􀡚"
M.GIT_INDICATOR = "􀂓"

-- My apps
M.DISCORD = "" -- Discord
M.PHOTOSHOP = ""
M.PHOTOS = ""
M.FIGMA = ""
M.THINGS = ""
M.DOWNLOAD_FOLX = "􁾮" -- folx (重複回避のため別名にしています)
M.ICON = "􀼱" -- SF Symbols
M.STEAM = "󰓓" -- Steam
M.SAFARI = "󰀹"
M.FONTBOOK = ""
M.VLC = "󰕼"

M.RAM = "󰓅"
M.DISK = "󰋊" -- disk utility
M.CPU = "󰘚"

return M
