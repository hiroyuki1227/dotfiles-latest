#
## MacOS specific zshrc
#
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# pnpm
# export PNPM_HOME="/Users/hrsuda/Library/pnpm"
# case ":$PATH:" in
#   *":$PNPM_HOME:"*) ;;
#   *) export PATH="$PNPM_HOME:$PATH" ;;
# esac
# pnpm end
#
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# place this after nvm initialization!
autoload -U add-zsh-hook

# Python development setup
export PATH="$(brew --prefix python)/libexec/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
#

# place this after nvm initialization!
load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

# sketchybar
# This will update the brew package count after running a brew upgrade, brew
# update or brew outdated command
# Personally I added "list" and "install", and everything that is after but
# that's just a personal preference.
# That way sketchybar updates when I run those commands as well
if command -v sketchybar &>/dev/null; then
  # When the zshrc file is ran, reload sketchybar, in case the theme was
  # switched
  # I disabled this as it was getting refreshed every time I opened the
  # terminal and if I restored a lot of sessions after rebooting it was a mess
  # sketchybar --reload

  # Define a custom 'brew' function to wrap the Homebrew command.
  function brew() {
    # Execute the original Homebrew command with all passed arguments.
    command brew "$@"
    # Check if the command includes "upgrade", "update", or "outdated".
    if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]] || [[ $* =~ "list" ]] || [[ $* =~ "install" ]] || [[ $* =~ "uninstall" ]] || [[ $* =~ "bundle" ]] || [[ $* =~ "doctor" ]] || [[ $* =~ "info" ]] || [[ $* =~ "cleanup" ]]; then
      # If so, notify SketchyBar to trigger a custom action.
      sketchybar --trigger brew_update
    fi
  }
fi

export CLICOLOR=1

export PATH=$PATH:/Users/hrsuda/.spicetify

# export PATH="$HOME/.rbenv/shims:$PATH"
# Rancher Desktop
# if [ -d "$HOME/.rd/bin" ] ; then
# export PATH="$HOME/.rd/bin:$PATH"
# fi
#
# Curl
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/curl/lib"
export CPPFLAGS="-I/opt/homebrew/opt/curl/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/curl/lib/pkgconfig"
#
if [ -f "$HOME/.obsidian/auth" ]; then
  source ~/.obsidian/auth
fi
# TeX Live
export PATH="/Library/TeX/texbin:$PATH"
# python uv setup
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"
export PATH="/Users/hrsuda/.local/bin:$PATH"
