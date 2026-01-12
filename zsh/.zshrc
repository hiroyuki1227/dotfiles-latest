# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

export TERM=xterm-256color

# Direct OS
case "$(uname -s)" in 
  Darwin)
    OS="Mac"
    ;;
  Linux)
    OS="Linux"
    OS="Unknown"
    ;;
esac

#
# Common setup
#
[[ ! -f ~/.config/zsh/common.sh ]] || source ~/.config/zsh/common.sh


if [[ "$OS" == "Mac" ]]; then
  source ~/.config/zsh/macos.sh
elif [[ "$OS" == "Linux" ]]; then
  source ~/.config/zsh/linux.sh
fi

[[ ! -f ~/.config/zsh/alias.sh ]] || source ~/.config/zsh/alias.sh
#
#
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
    neovim
    neovim/mozumasu
    neovim/CodeOps
    neovim/AstroNvim
    neovim/nvchad
    neovim/LazyVim
    neovim/neobean 
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


# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/hrsuda/.lmstudio/bin"
# End of LM Studio CLI section


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
