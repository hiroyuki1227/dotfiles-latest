# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# Direct OS
case "$(uname -s)" in 
  Darwin)
    OS="Mac"
    ;;
  Linux)
    OS="Linux"
    ;;
  *)
    OS="Unknown"
    ;;
esac

# # macOS-scpcific confirmations
# [[ ! -f ~/dotfiles/zsh/.zsh-shard ]] || source ~/dotfiles/dotfiles/zsh/.zsh-shard
# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history 
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

if [[ "$OS" == "Mac" ]]; then
  source ~/dotfiles/zsh/zsh/zshrc-macos.sh
elif [[ "$OS" == "Linux" ]]; then
  source ~/dotfiles/zsh/zsh/zshrc-linux.sh
fi

#
# ---- FZF -----

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

source ~/.fzf-git/fzf-git.sh

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

function pkill() {
  ps aux | fzf --height 40% --layout=reverse --prompt="Select process to kill: " | awk '{print $2}' | xargs -r sudo kill 
}
# ----- Bat (better cat) -----

# export BAT_THEME=tokyonight_night

# ---- Eza (better ls) -----
if command -v eza &>/dev/null; then
  alias ls="eza --icons=always"
  alias ll="eza --icons=always -lhg"
  alias lla="eza --icons=always -alhg"
  alias tree="eza --icons=always --tree" 
fi
# ----- Bat (better cat) -----
export BAT_THEME="gruvbox-dark"
export BAT_PAGER="less -R"

# export BAT_THEME=tokyonight_night

if builtin command -v bat > /dev/null; then
  alias catt="bat"
  alias cat="bat --paging=never --style=plain"
  alias cata="bat --show-all --pading=never"
fi


# ---- TheFuck -----

# thefuck alias
eval $(thefuck --alias)
eval $(thefuck --alias fk)

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"

# starship shell setup
if command -v starship &>/dev/null; then
  export STARSHIP_CONFIG=~/.config/starship/starship.toml
  export STARSHIP_CACHE=~/.starship/cache
  eval "$(starship init zsh)" >/dev/null 2>&1
fi 

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
# export PATH="/Users/hrsuda/.rd/bin:$PATH"
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

function t() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}
# OSC 133 sequences
preexec() { printf "\033]133;A\033\\" }
precmd()  { printf "\033]133;B\033\\" }

export XDG_STATE_HOME="$HOME/.local/state"
# NVIM_APPNAME
# ===== Neovim AppName Switcher ===========================

# デフォルトの XDG_STATE_HOME を定義（なければ）
: ${XDG_STATE_HOME:="${HOME}/.local/state"}

if command -v nvim &> /dev/null; then
  # NVIM_APPNAME が未保存なら初期値を astronvim に設定
  if [ ! -f "${XDG_STATE_HOME}/nvim_appname" ]; then
    echo LazyNvim > "${XDG_STATE_HOME}/nvim_appname"
  fi

  # NVIM_APPNAME を読み込んで環境変数に設定
  export NVIM_APPNAME="$(<"${XDG_STATE_HOME}/nvim_appname")"

  # 使用可能な Neovim プロファイル一覧
  nvim_appnames=(
    nvim
    AstroNvim
    nvchad
    LazyVim
    neobean 
  )

  # Neovim プロファイル切り替え関数
  nvim_appname() {
    local switch_nvim_appname
    switch_nvim_appname=$(gum choose --select-if-one \
      --header "Current NVIM_APPNAME: ${NVIM_APPNAME}" \
      "${nvim_appnames[@]}")

    if [ -n "${switch_nvim_appname}" ]; then
      echo "${switch_nvim_appname}" > "${XDG_STATE_HOME}/nvim_appname"
      export NVIM_APPNAME="$(<"${XDG_STATE_HOME}/nvim_appname")"
      echo "✅ Switched NVIM_APPNAME to: ${switch_nvim_appname}"
    else
      echo "❌ Cancelled. NVIM_APPNAME unchanged: ${NVIM_APPNAME}"
    fi
  }

  # vi/vim コマンドを Neovim に置き換え（プロファイル反映）
  vi()  { nvim "$@"; }
  vim() { nvim "$@"; }
fi


[[ ! -f ~/.alias ]] || source ~/.alias
