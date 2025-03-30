## **ターミナルウィンドウを開く**

Mac でターミナル ウィンドウを開きます。カラースキームが適切に機能するには、True Color ターミナルが必要です。

*iTerm2*を使用しています

## **自作をインストールする**

次のコマンドを実行します。

```Bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

必要に応じて、プロンプトが表示されたら、ここにパスワードを入力し、Enter キーを押します。 XCode コマンド ライン ツールをインストールしていない場合は、プロンプトが表示されたら Enter キーを押すと、homebrew によってこれもインストールされます。

## **パスに追加 (Apple Silicon Macbook のみ)**

インストール後、パスに追加します。 Intel Mac ではこの手順は必要ありません。

これを行うには、次の 2 つのコマンドを実行します。

```Bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## **必要に応じて iTerm2 をインストールする**

True Color 端末をお持ちでない場合は、iTerm2 を homebrew でインストールします。

```Bash
brew tap homebrew/cask-fonts
```

次に、この端末に切り替えます。

## **Nerd フォントをインストールする**

Meslo Nerd Fontを使用しています。インストールするには次のようにします。

```Bash
brew tap homebrew/cask-fonts
```

そして、次のようにします。

```Bash
brew install font-meslo-lg-nerd-font
```

次に、iTerm2 設定を開き、 **[プロファイル] > [テキスト]**`**CMD+,**`でフォントを**MesloLGS Nerd Font
Monoに変更します。**

## **Neovim をインストールする**

```Bash
brew install neovim
```

## **Ripgrepをインストールする**

```Bash
brew install ripgrep
```

## Nodeをインストールする

```Bash
brew install node
```

## **初期ファイル構造のセットアップ**

設定は にあります`**~/.config/nvim**`。

次のコマンドを使用して、初期ファイル構造をセットアップしましょう。

nvim config ディレクトリを作成します。

```Bash
mkdir -p ~/.config/nvim
-p 親ディレクトリがまだ存在しない場合は、親ディレクトリを作成するためにも使用されます。

cd ~/.config/nvi
```

メイン`**init.lua**`ファイルを作成します。

```Bash
touch init.lua
```

ディレクトリを作成します`**lua/josean/core**`。

*私が「josean」を使用するときはいつでも、これをあなたの名前に置き換えることができます*

```Bash
mkdir -p lua/josean/core
```

プラグイン ディレクトリを作成します (すべてのプラグイン構成/仕様が含まれます)。

```Bash
mkdir -p lua/josean/plugins
```

ファイルを作成します`**lazy.lua**`(lazy.nvim プラグイン マネージャーのセットアップ/構成に使用されます):

```Bash
touch lua/josean/lazy.lua
```

## **コアオプションのセットアップ**

ログインしていることを確認して`**~/.config/nvim**`、構成を開きます。

```Bash
nvim .
```

コアフォルダーに移動し、 を押して`**%**`ファイルを作成し、「options.lua」という名前を付けます。

このファイルに以下を追加します。

```lua
vim.cmd("let g:netrw_liststyle = 3")
```

エクスプローラーを開き`**:Explore**`、メイン`**init.lua**`ファイルに移動します。

以下を追加して、起動時に基本オプションをロードします。

```lua
require("josean.core.options")
```

Neovim を で閉じて`**:w**`、再度開きます`**nvim .**`

「options.lua」に戻り、以下を追加して残りのオプションを設定します。

```lua
local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false
```

する`**:e lua/josean/core/init.lua**`

以下を追加します。

```lua
require("josean.core.options")
```

エクスプローラーを開いて`**:Explore**`メインの init.lua ファイルに移動し、require を次のように変更します。

```lua
require("josean.core")
```

## **コアキーマップのセットアップ**

する`**:e lua/josean/core/keymaps.lua**`

そして、このファイルに以下を追加します。

```lua
-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- crazdog
keymap.set("n", "te", "<cmd>tabedit<CR>")
keymap.set("n", "<tab>", "<cmd>tabn<CR>", opts)
keymap.set("n", "<s-tab>", "<cmd>tabp<CR>", opts)

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
```

でエクスプローラーを開き`**:Explore**`、`**lua/josean/core/init.lua**`以下を開いて追加します。

```lua
require("josean.core.options")
require("josean.core.keymaps")
```

で終了し`**:q**`、Neovim に再入力します`**nvim .**`

## **Lazy.nvim のセットアップ**

「lazy.lua」に移動し、次のコードをブートストラップ Lazy.nvim に追加します。

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

```lua
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
```

次に、lazy.nvim を次のように構成します。

```lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("josean.plugins")
```

*「josean」の代わりに自分の名前を使用している場合は、ここでもそれを自分の名前に変更してください*

次に、エクスプローラーを開き`**:Explore**`、メイン`**init.lua**`ファイルに移動します。

これに以下を追加します。

```lua
require("josean.core")
require("josean.lazy")
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

**これで、lazy.nvim UI が表示され**`**:Lazy**`**、UI を閉じることができます。**`**q**`

## **Plenaryと vim-tmux-navigator をインストールする**

する`**:e lua/josean/plugins/init.lua**`

以下を追加して、**プレナリー**と**vim-tmux-navigator**をインストールします。

```Bash
return {
  "nvim-lua/plenary.nvim", -- lua functions that many plugins use
  "christoomey/vim-tmux-navigator", -- tmux & split window navigation
}
```

これを追加した後、ファイルを保存すると、 を実行して`**:Lazy**`から と入力することで手動でインストールできます`**I**`。

インストール後、 で UI を閉じると、たとえば`**q**`でプラグインを手動でロードできます。`**:Lazy reload vim-tmux-navigator**`

`**:q**`それ以外の場合は、 で終了し、 Neovim に再入力することもできます`**nvim .**`。これは自動的に行われます。

## **tokyonight colorcheme のインストールと設定**

する`**:e lua/josean/plugins/colorscheme.lua**`

このファイルに次の内容を追加します。

```Bash
return {
  {
    "folke/tokyonight.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      local bg = "\#011628"
      local bg_dark = "\#011423"
      local bg_highlight = "\#143652"
      local bg_search = "\#0A64AC"
      local bg_visual = "\#275378"
      local fg = "\#CBE0F0"
      local fg_dark = "\#B4D0E9"
      local fg_gutter = "\#627E97"
      local border = "\#547998"

      require("tokyonight").setup({
        style = "night",
        on_colors = function(colors)
          colors.bg = bg
          colors.bg_dark = bg_dark
          colors.bg_float = bg_dark
          colors.bg_highlight = bg_highlight
          colors.bg_popup = bg_dark
          colors.bg_search = bg_search
          colors.bg_sidebar = bg_dark
          colors.bg_statusline = bg_dark
          colors.bg_visual = bg_visual
          colors.border = border
          colors.fg = fg
          colors.fg_dark = fg_dark
          colors.fg_float = fg
          colors.fg_gutter = fg_gutter
          colors.fg_sidebar = fg_dark
        end,
      })
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}
```

**これにより、 tokyonight が**カラースキームとして設定され、好みに応じてその色の一部が変更されます。

で終了し`**:q**`、Neovim に再入力します`**nvim .**`

## **nvim-tree ファイルエクスプローラーのセットアップ**

する`**:e lua/josean/plugins/nvim-tree.lua**`

このファイルに以下を追加します。

```Bash
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")

    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup({
      view = {
        width = 35,
        relativenumber = true,
      },
      -- change folder arrow icons
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "", -- arrow when folder is closed
              arrow_open = "", -- arrow when folder is open
            },
          },
        },
      },
      -- disable window_picker for
      -- explorer to work well with
      -- window splits
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        custom = { ".DS_Store" },
      },
      git = {
        ignore = false,
      },
    })

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
  end
}
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

## **どのキーを設定するか**

Which-key は、使用できるキーマップを確認するのに最適です。

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

`**plugins**`新しいファイルを追加して呼び出し`**a**`ます`**which-key.lua**`

これをファイルに追加します。

```Bash
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
}
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

## **Setup telescope fuzzy finder**

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

`**plugins**`新しいファイルを追加して呼び出し`**a**`ます`**telescope.lua**`

これをファイルに追加します。

```Bash
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    telescope.load_extension("fzf")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
  end,
}
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

## **Setup a greeter**

alpha-nvim を使用して Neovim スタートアップ用のグリーターをセットアップします

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

`**plugins**`新しいファイルを追加して呼び出し`**a**`ます`**alpha.lua**`

次のコードを追加します。

```Bash
return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Set header
    dashboard.section.header.val = {
      "                                                     ",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                     ",
    }

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
      dashboard.button("SPC ee", "  > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
      dashboard.button("SPC ff", "󰱼 > Find File", "<cmd>Telescope find_files<CR>"),
      dashboard.button("SPC fs", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
      dashboard.button("q", " > Quit NVIM", "<cmd>qa<CR>"),
    }

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

## **自動セッションマネージャーのセットアップ**

自動セッション管理は、Neovim を終了する前にセッションを自動保存し、戻ってきたときに作業に戻るのに最適です。

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

`**plugins**`新しいファイルを追加して呼び出し`**a**`ます`**auto-session.lua**`

このファイルに以下を追加します。

```Bash
return {
  "rmagatti/auto-session",
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      auto_restore_enabled = false,
      auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
    })

    local keymap = vim.keymap

    keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
    keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory
  end,
}
```

で終了し`**:q**`、Neovim に再入力します`**nvim .**`

プロジェクトで作業しているときに、すべてを閉じることができ、このディレクトリで Neovim を再度開くと、ワークスペース/セッションの復元に`**:qa**`使用できます。`**<leader>wr**`

## **Lazy.nvimのchange_detection通知を無効にする**

少し煩わしいと思う、lazy.nvimのchange_detection通知を無効にしましょう。

`**lazy.lua**`次のようにコードに移動して変更します。

```Bash
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("josean.plugins", {
  change_detection = {
    notify = false,
  },
})
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

## **タブの見栄えを良くするためにバッファラインを設定する**

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

`**plugins**`新しいファイルを追加して呼び出し`**a**`ます`**bufferline.lua**`

次のコードを追加します。

```Bash
return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  opts = {
    options = {
      mode = "tabs",
      separator_style = "slant",
    },
  },
}
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

## **より良いステータスラインのために lualine をセットアップする**

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

`**plugins**`新しいファイルを追加して呼び出し`**a**`ます`**lualine.lua**`

次のコードを追加します。

```Bash
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count

    local colors = {
      blue = "\#65D1FF",
      green = "\#3EFFDC",
      violet = "\#FF61EF",
      yellow = "\#FFDA7B",
      red = "\#FF4A4A",
      fg = "\#c3ccdc",
      bg = "\#112638",
      inactive_bg = "\#2c3043",
    }

    local my_lualine_theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      insert = {
        a = { bg = colors.green, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      visual = {
        a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      command = {
        a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      replace = {
        a = { bg = colors.red, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      inactive = {
        a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
        b = { bg = colors.inactive_bg, fg = colors.semilightgray },
        c = { bg = colors.inactive_bg, fg = colors.semilightgray },
      },
    }

    -- configure lualine with modified theme
    lualine.setup({
      options = {
        theme = my_lualine_theme,
      },
      sections = {
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "\#ff9e64" },
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
      },
    })
  end,
}
```

Lualine が Lazy.nvim を通じて保留中のプラグイン更新を表示できるようにするには、「lazy.lua」を開いて次のように変更します。

```Bash
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("josean.plugins", {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

## **Dressing.nvim のセットアップ**

`**vim.ui.select**`Dressing.nvim はとの UI を改善します`**vim.ui.input**`

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

`**plugins**`新しいファイルを追加して呼び出し`**a**`ます`**dressing.lua**`

次のコードを追加します。

```Bash
return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
}
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

## **vim-maximizer のセットアップ**

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

`**plugins**`新しいファイルを追加して呼び出し`**a**`ます`**vim-maximizer.lua**`

次のコードを追加します。

```Bash
return {
  "szw/vim-maximizer",
  keys = {
    { "<leader>sm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/minimize a split" },
  },
}
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

## **Treessitteのセットアップ**

Treesitter は、より優れた構文強調表示、インデント、自動タグ付け、増分選択、その他多くの優れた機能を提供する素晴らしい Neovim 機能です。

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

`**plugins**`新しいファイルを追加して呼び出し`**a**`ます`**treesitter.lua**`

次のコードを追加します。

```Bash
return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- import nvim-treesitter plugin
    local treesitter = require("nvim-treesitter.configs")

    -- configure treesitter
    treesitter.setup({ -- enable syntax highlighting
      highlight = {
        enable = true,
      },
      -- enable indentation
      indent = { enable = true },
      -- enable autotagging (w/ nvim-ts-autotag plugin)
      autotag = {
        enable = true,
      },
      -- ensure these language parsers are installed
      ensure_installed = {
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "prisma",
        "markdown",
        "markdown_inline",
        "svelte",
        "graphql",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "query",
        "vimdoc",
        "c",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

## **インデントガイドの設定**

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

`**plugins**`新しいファイルを追加して呼び出し`**a**`ます`**indent-blankline.lua**`

次のコードを追加します。

```Bash
return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPre", "BufNewFile" },
  main = "ibl",
  opts = {
    indent = { char = "┊" },
  },
}
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

## **オートコンプリートのセットアップ**

「nvim-cmp」で補完を設定して、入力時に候補を取得します。

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

`**plugins**`新しいファイルを追加して呼び出し`**a**`ます`**nvim-cmp.lua**`

次のコードを追加します。

```Bash
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- source for file system paths
    {
      "L3MON4D3/LuaSnip",
      -- follow latest release.
      version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      -- install jsregexp (optional!).
      build = "make install_jsregexp",
    },
    "saadparwaiz1/cmp_luasnip", -- for autocompletion
    "rafamadriz/friendly-snippets", -- useful snippets
    "onsails/lspkind.nvim", -- vs-code like pictograms
  },
  config = function()
    local cmp = require("cmp")

    local luasnip = require("luasnip")

    local lspkind = require("lspkind")

    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(), -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
      }),
      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = "luasnip" }, -- snippets
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
      }),

      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
        format = lspkind.cmp_format({
          maxwidth = 50,
          ellipsis_char = "...",
        }),
      },
    })
  end,
}
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

## **自動終了ペアの設定**

このプラグインは、括弧、括弧、中括弧、引用符、一重引用符、タグなどの周囲の文字を自動的に閉じるのに役立ちます。

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

`**plugins**`新しいファイルを追加して呼び出し`**a**`ます`**autopairs.lua**`

次のコードを追加します。

```Bash
return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
  config = function()
    -- import nvim-autopairs
    local autopairs = require("nvim-autopairs")

    -- configure autopairs
    autopairs.setup({
      check_ts = true, -- enable treesitter
      ts_config = {
        lua = { "string" }, -- don't add pairs in lua string treesitter nodes
        javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
        java = false, -- don't check treesitter on java
      },
    })

    -- import nvim-autopairs completion functionality
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

    -- import nvim-cmp plugin (completions plugin)
    local cmp = require("cmp")

    -- make autopairs and completion work together
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

## **コメントプラグインの設定**

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

`**plugins**`新しいファイルを追加して呼び出し`**a**`ます`**comment.lua**`

次のコードを追加します。

```Bash
return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    -- import comment plugin safely
    local comment = require("Comment")

    local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

    -- enable comment
    comment.setup({
      -- for commenting tsx, jsx, svelte, html files
      pre_hook = ts_context_commentstring.create_pre_hook(),
    })
  end,
}
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

## **Todo コメントを設定する**

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

`**plugins**`新しいファイルを追加して呼び出し`**a**`ます`**todo-comments.lua**`

次のコードを追加します。

```Bash
return {
  "folke/todo-comments.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local todo_comments = require("todo-comments")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "]t", function()
      todo_comments.jump_next()
    end, { desc = "Next todo comment" })

    keymap.set("n", "[t", function()
      todo_comments.jump_prev()
    end, { desc = "Previous todo comment" })

    todo_comments.setup()
  end,
}
```

`**telescope.lua**`**telescoope**で探す`**<leader>ff**`

このファイルを開いて以下を追加すると、Telescope で Todo を検索できるようになります。

```Bash
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    telescope.load_extension("fzf")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
  end,
}
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

## **置換プラグインのセットアップ**

このプラグインを使用する`**s**`と、後にを使用して`**motion**`、以前にコピーしたテキストを置き換えることができます。

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

`**plugins**`新しいファイルを追加して呼び出し`**a**`ます`**substitute.lua**`

次のコードを追加します。

```Bash
return {
  "gbprod/substitute.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local substitute = require("substitute")

    substitute.setup()

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    vim.keymap.set("n", "s", substitute.operator, { desc = "Substitute with motion" })
    vim.keymap.set("n", "ss", substitute.line, { desc = "Substitute line" })
    vim.keymap.set("n", "S", substitute.eol, { desc = "Substitute to end of line" })
    vim.keymap.set("x", "s", substitute.visual, { desc = "Substitute in visual mode" })
  end,
}
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

## **nvim-surround のセットアップ**

このプラグインは、周囲のシンボルやタグを追加、削除、変更するのに最適です。

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

`**plugins**`新しいファイルを追加して呼び出し`**a**`ます`**surround.lua**`

次のコードを追加します。

```Bash
return {
  "kylechui/nvim-surround",
  event = { "BufReadPre", "BufNewFile" },
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  config = true,
}
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

## **LSP のセットアップ**

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

で`**lua/josean**`新しいディレクトリを追加し`**a**`、それを呼び出します`**lsp/**`

次のように新しいディレクトリを認識できる`**lazy.lua**`ように、ディレクトリに移動して変更します。`**lazy.nvimlsp**`

```Bash
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ { import = "josean.plugins" }, { import = "josean.plugins.lsp" } }, {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})
```

### **mason.nvim のセットアップ**

Mason.nvim は、作業対象の言語に必要なすべての言語サーバーのインストールと管理に使用されます。

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

`**plugins/lsp**`新しいファイルを追加して呼び出し`**a**`ます`**mason.lua**`

次のコードを追加します。

```Bash
return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "tsserver",
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "lua_ls",
        "graphql",
        "emmet_ls",
        "prismals",
        "pyright",
      },
    })
  end,
}
```

### **nvim-lspconfig のセットアップ**

Nvim-lspconfig は、言語サーバーを構成するために使用されます。

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

`**plugins/lsp**`新しいファイルを追加して呼び出し`**a**`ます`**lspconfig.lua**`

次のコードを追加します。

```Bash
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import mason_lspconfig plugin
    local mason_lspconfig = require("mason-lspconfig")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    mason_lspconfig.setup_handlers({
      -- default handler for installed servers
      function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
        })
      end,
      ["svelte"] = function()
        -- configure svelte server
        lspconfig["svelte"].setup({
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePost", {
              pattern = { "*.js", "*.ts" },
              callback = function(ctx)
                -- Here use ctx.match instead of ctx.file
                client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
              end,
            })
          end,
        })
      end,
      ["graphql"] = function()
        -- configure graphql language server
        lspconfig["graphql"].setup({
          capabilities = capabilities,
          filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
        })
      end,
      ["emmet_ls"] = function()
        -- configure emmet language server
        lspconfig["emmet_ls"].setup({
          capabilities = capabilities,
          filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
        })
      end,
      ["lua_ls"] = function()
        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              -- make the language server recognize "vim" global
              diagnostics = {
                globals = { "vim" },
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        })
      end,
    })
  end,
}
```

*以下のコードでは、*`_**mason_lspconfig.setup_handlers**_`*言語サーバーのデフォルトと、 、 、 、および のカスタム構成をセットアップし*`_**svelte**_`*て*`_**graphql**_`*い*`_**emmet_ls**_`*ます*`_**lua_ls**_`*。これは、使用する言語によって異なる場合があります。*

に移動し`**nvim-cmp.lua**`て次の変更を加え、lsp を補完ソースとして追加します。

```Bash
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- source for file system paths
    {
      "L3MON4D3/LuaSnip",
      -- follow latest release.
      version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      -- install jsregexp (optional!).
      build = "make install_jsregexp",
    },
    "saadparwaiz1/cmp_luasnip", -- for autocompletion
    "rafamadriz/friendly-snippets", -- useful snippets
    "onsails/lspkind.nvim", -- vs-code like pictograms
  },
  config = function()
    local cmp = require("cmp")

    local luasnip = require("luasnip")

    local lspkind = require("lspkind")

    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(), -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
      }),
      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = "nvim_lsp"},
        { name = "luasnip" }, -- snippets
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
      }),

      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
        format = lspkind.cmp_format({
          maxwidth = 50,
          ellipsis_char = "...",
        }),
      },
    })
  end,
}
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

## **セットアップトラブル.nvim**

これは、lsp や todo コメントなどと対話するための優れた機能を追加する別のプラグインです。

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

`**plugins**`新しいファイルを追加して呼び出し`**a**`ます`**trouble.lua**`

次のコードを追加します。

```Bash
return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
  keys = {
    { "<leader>xx", "<cmd>TroubleToggle<CR>", desc = "Open/close trouble list" },
    { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Open trouble workspace diagnostics" },
    { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", desc = "Open trouble document diagnostics" },
    { "<leader>xq", "<cmd>TroubleToggle quickfix<CR>", desc = "Open trouble quickfix list" },
    { "<leader>xl", "<cmd>TroubleToggle loclist<CR>", desc = "Open trouble location list" },
    { "<leader>xt", "<cmd>TodoTrouble<CR>", desc = "Open todos in trouble" },
  },
}
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

## **フォーマットのセットアップ**

`**conform.nvim**`Neovim でフォーマットを設定していきます。

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

`**plugins**`新しいファイルを追加して呼び出し`**a**`ます`**formatting.lua**`

次のコードを追加します。

```Bash
return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
```

`**mason.lua**`フォーマッタを自動インストールするには、以下に移動して追加します。

```Bash
return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "tsserver",
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "lua_ls",
        "graphql",
        "emmet_ls",
        "prismals",
        "pyright",
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "isort", -- python formatter
        "black", -- python formatter
      },
    })
  end,
}
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

## **リンティングのセットアップ**

Neovim で lint をセットアップするには nvim-lint を使用します。

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

`**plugins**`新しいファイルを追加して呼び出し`**a**`ます`**linting.lua**`

次のコードを追加します。

```Bash
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      python = { "pylint" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
```

`**mason.lua**`リンターを自動インストールするには、以下に移動して追加します。

```Bash
return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "tsserver",
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "lua_ls",
        "graphql",
        "emmet_ls",
        "prismals",
        "pyright",
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "isort", -- python formatter
        "black", -- python formatter
        "pylint", -- python linter
        "eslint_d", -- js linter
      },
    })
  end,
}
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

## **git 機能のセットアップ**

### **gitsigns プラグインのセットアップ**

Gitsigns は、Neovim で git hunk を操作するための優れたプラグインです。

ファイル エクスプローラーを開きます`**<leader>ee**`(私の設定では`**<leader>**`キーは です`**space**`)。

`**plugins**`新しいファイルを追加して呼び出し`**a**`ます`**gitsigns.lua**`

次のコードを追加します。

```Bash
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      -- Navigation
      map("n", "]h", gs.next_hunk, "Next Hunk")
      map("n", "[h", gs.prev_hunk, "Prev Hunk")

      -- Actions
      map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
      map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
      map("v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage hunk")
      map("v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Reset hunk")

      map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
      map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")

      map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")

      map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")

      map("n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, "Blame line")
      map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle line blame")

      map("n", "<leader>hd", gs.diffthis, "Diff this")
      map("n", "<leader>hD", function()
        gs.diffthis("~")
      end, "Diff this ~")

      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
    end,
  },
}
```

で終了します`**:q**`

### **Lazygit 統合のセットアップ**

Lazygit がインストールされていることを確認してください。

homebrew でインストールします。

```Bash
brew install jesseduffield/lazygit/lazygit
```

Neovim を開く`**nvim .**`

`**plugins**`新しいファイルを追加して呼び出し`**a**`ます`**lazygit.lua**`

次のコードを追加します。

```Bash
return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  -- optional for floating window border decoration
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- setting the keybinding for LazyGit with 'keys' is recommended in
  -- order to load the plugin when the command is run for the first time
  keys = {
    { "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open lazy git" },
  },
}
```

で終了し`**:q**`、Neovim に再入力します`**nvim**`

基本的にはlazyvimを中心に、少し設定を追加している。基本的には公式の通り設定すれば良いと思うが、以下の設定はあまり書いてないので備忘録として記載する。

```Bash
return {
    "keaising/im-select.nvim",
    vscode = true,
    config = function()
        require("im_select").setup({
            -- IM will be set to `default_im_select` in `normal` mode
            -- For Windows/WSL, default: "1033", aka: English US Keyboard
            -- For macOS, default: "com.apple.keylayout.ABC", aka: US
            -- For Linux, default:
            --               "keyboard-us" for Fcitx5
            --               "1" for Fcitx
            --               "xkb:us::eng" for ibus
            -- You can use `im-select` or `fcitx5-remote -n` to get the IM's name
            -- default_im_select  = "com.apple.keylayout.ABC",

            -- Can be binary's name or binary's full path,
            -- e.g. 'im-select' or '/usr/local/bin/im-select'
            -- For Windows/WSL, default: "im-select.exe"
            -- For macOS, default: "im-select"
            -- For Linux, default: "fcitx5-remote" or "fcitx-remote" or "ibus"
            -- default_command = 'im-select.exe',

            -- Restore the default input method state when the following events are triggered
            set_default_events = { "VimEnter", "FocusGained", "InsertLeave", "CmdlineLeave" },

            -- Restore the previous used input method state when the following events
            -- are triggered, if you don't want to restore previous used im in Insert mode,
            -- e.g. deprecated `disable_auto_restore = 1`, just let it empty
            -- as `set_previous_events = {}`
            -- set_previous_events = { "InsertEnter" },

            -- Show notification about how to install executable binary when binary missed
            keep_quiet_on_no_binary = false,

            -- Async run `default_command` to switch IM or not
            async_switch_im = true,
        })
    end,
}

```

## **これで完了です。 🚀**
