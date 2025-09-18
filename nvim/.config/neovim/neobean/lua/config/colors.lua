-- ~/github/dotfiles-latest/neovim/neobean/lua/config/colors.lua

-- load the colors once when the module is required and then expose the colors
-- directly. This avoids the need to call load_colors() in every file

-- Function to load colors from the external file
local function load_colors()
  local colors = {}
  -- Get directory of this file
  local script_dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
  local local_file = script_dir .. "active-colorscheme.sh"
  local fallback_file = os.getenv("HOME") .. "/.config/neovim/neobean/lua/config/active-colorscheme.sh"

  -- Pick first available file
  local active_file = vim.fn.filereadable(local_file) == 1 and local_file or fallback_file

  local file = io.open(active_file, "r")
  if not file then
    error("Could not open the active colorscheme file: " .. active_file)
  end

  for line in file:lines() do
    if not line:match("^%s*#") and not line:match("^%s*$") and not line:match("^wallpaper=") then
      local name, value = line:match("^(%S+)=%s*(.+)")
      if name and value then
        colors[name] = value:gsub('"', "")
      end
    end
  end

  file:close()
  return colors
end

-- Load colors when the module is required
local colors = load_colors()

-- Check if the 'vim' global exists (i.e., if running in Neovim)
if _G.vim then
  for name, hex in pairs(colors) do
    vim.api.nvim_set_hl(0, name, { fg = hex })
  end
end

-- Return the colors table for external usage (like wezterm)
return colors
