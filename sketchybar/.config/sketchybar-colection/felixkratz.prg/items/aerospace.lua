local colors = require("colors")
local icons = require("icons")

local function exec(cmd)
	local handle = io.popen(cmd)
	if not handle then
		return ""
	end
	local result = handle:read("*a")
	handle:close()
	return result:gsub("%s+$", "")
end

local function icon_map(app)
	return exec(os.getenv("HOME") .. "/.config/sketchybar/plugins/icon_map.sh " .. app)
end

local function window_state(name)
	local focused = exec("aerospace list-windows --focused --format '%{window-id} %{app-name} %{is-floating}'")

	if focused == "" then
		sbar.exec(
			string.format(
				"sketchybar --set %s icon=%s icon.color=%s label.drawing=off",
				name,
				icons.YABAI_FLOAT,
				colors.MAGENTA
			)
		)
		return
	end

	local is_floating = focused:match("%S+%s+%S+%s+(%S+)")

	if is_floating == "true" then
		sbar.exec(
			string.format(
				"sketchybar --set %s icon=%s icon.color=%s label.drawing=off",
				name,
				icons.YABAI_FLOAT,
				colors.MAGENTA
			)
		)
	else
		sbar.exec(
			string.format(
				"sketchybar --set %s icon=%s icon.color=%s label.drawing=off",
				name,
				icons.YABAI_GRID,
				colors.ORANGE
			)
		)
	end
end

local function windows_on_spaces()
	local args = {}

	local workspaces = exec("aerospace list-workspaces --all")
	for workspace in workspaces:gmatch("[^\n]+") do
		local icon_strip = " "
		local apps = exec(string.format("aerospace list-windows --workspace %s --format '%%{app-name}'", workspace))

		if apps ~= "" then
			for app in apps:gmatch("[^\n]+") do
				if app ~= "" then
					local icon = icon_map(app)
					icon_strip = icon_strip .. " " .. icon
				end
			end
		end

		table.insert(args, string.format("--set space.%s label='%s' label.drawing=on", workspace, icon_strip))
	end

	if #args > 0 then
		sbar.exec("sketchybar -m " .. table.concat(args, " "))
	end
end

local function mouse_clicked(name)
	local win_id = exec("aerospace list-windows --focused --format '%{window-id}'")
	local floating = exec("aerospace list-windows --focused --format '%{is-floating}'")

	if win_id ~= "" then
		if floating == "true" then
			sbar.exec("aerospace layout tiling")
		else
			sbar.exec("aerospace layout floating")
		end
	end

	window_state(name)
end

-- イベントハンドラの登録
local sender = os.getenv("SENDER")
local name = os.getenv("NAME")

if sender == "mouse.clicked" then
	mouse_clicked(name)
elseif sender == "forced" then
	os.exit(0)
elseif sender == "window_focus" then
	window_state(name)
elseif sender == "windows_on_spaces" then
	windows_on_spaces()
end
