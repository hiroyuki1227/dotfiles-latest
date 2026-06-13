-- items/widgets/brew.lua
-- Widget to display Brew update information (inside the popup)

local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Helper to dynamically generate each package row in the popup
local function add_package_item(name, current_ver, new_ver, index)
	local item_name = "brew.widget.pkg." .. index

	sbar.add("item", item_name, {
		position = "popup.brew",
		width = 280,
		align = "left",
		label = {
			string = name .. "  " .. current_ver .. " → " .. new_ver,
			font = {
				family = settings.font.text,
				size = 12,
			},
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
		click_script = "", -- Row click does nothing (handled on the brew.lua side)
	})
end

-- Widget popup header
local brew_header = sbar.add("item", "brew.widget.header", {
	position = "popup.brew",
	width = 280,
	align = "center",
	label = {
		string = "Brew Updates",
		font = {
			family = settings.font.text,
			style = "Bold",
			size = 13,
		},
		color = colors.white,
	},
	icon = {
		drawing = false,
	},
	background = {
		color = colors.bg2,
		border_color = colors.transparent,
		height = 28,
	},
	padding_left = 0,
	padding_right = 0,
})

-- Separator
local brew_separator = sbar.add("item", "brew.widget.sep", {
	position = "popup.brew",
	width = 280,
	background = {
		color = colors.grey,
		height = 1,
	},
	icon = { drawing = false },
	label = { drawing = false },
})

-- "Update All" button
local brew_update_all = sbar.add("item", "brew.widget.update_all", {
	position = "popup.brew",
	width = 280,
	align = "center",
	label = {
		string = "  Update All",
		font = {
			family = settings.font.text,
			style = "Bold",
			size = 13,
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

-- Public function to render the package list
-- packages: array of { {name, current, new}, ... }
local M = {}

function M.render(packages)
	-- Remove all existing package rows before rerendering
	for i = 1, 50 do
		local n = "brew.widget.pkg." .. i
		sbar.remove(n)
	end

	if #packages == 0 then
		-- No updates available
		sbar.add("item", "brew.widget.pkg.1", {
			position = "popup.brew",
			width = 280,
			align = "center",
			label = {
				string = "All up to date ✓",
				color = colors.green,
				font = { size = 13 },
			},
			icon = { drawing = false },
			background = { color = colors.transparent },
		})
	else
		for i, pkg in ipairs(packages) do
			add_package_item(pkg.name, pkg.current, pkg.new, i)
		end
	end
end

return M
