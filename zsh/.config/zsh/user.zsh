#  Startup 
# Commands to execute on startup (before the prompt is shown)
# Check if the interactive shell option is set
if [[ $- == *i* ]]; then
    # This is a good place to load graphic/ascii art, display system information, etc.
    if command -v pokego >/dev/null; then
        pokego --no-title -r 1,3,6
    elif command -v pokemon-colorscripts >/dev/null; then
        pokemon-colorscripts --no-title -r 1,3,6
    elif command -v fastfetch >/dev/null; then
        if do_render "image"; then
            fastfetch --logo-type kitty
        fi
    fi
fi

#   Overrides 
HYDE_ZSH_NO_PLUGINS=1 # Set to 1 to disable loading of oh-my-zsh plugins, useful if you want to use your zsh plugins system 
# unset HYDE_ZSH_PROMPT # Uncomment to unset/disable loading of prompts from HyDE and let you load your own prompts
# HYDE_ZSH_COMPINIT_CHECK=1 # Set 24 (hours) per compinit security check // lessens startup time
# HYDE_ZSH_OMZ_DEFER=1 # Set to 1 to defer loading of oh-my-zsh plugins ONLY if prompt is already loaded

if [[ ${HYDE_ZSH_NO_PLUGINS} != "1" ]]; then
    #  OMZ Plugins 
    # manually add your oh-my-zsh plugins here
    plugins=(
        "sudo"
    )
fi

#
#
#
# Aliases
#
alias reload-zsh="source ~/.zshrc"
alias edit-zsh="nvim ~/.zshrc"
alias ide="~/.scripts/ide"

# Weather
alias forecast='curl "https://wttr.in/wylie?1&F&q"'
alias weather='curl "https://wttr.in/wylie?format=1"'

#Git
alias ga='git add'
alias gap='git add -p'
alias gs='git status'
alias gpr='git pull -r'
alias gl='git lg'
alias glo='git log --oneline'
alias gcm='git commit -m'
alias pear='git pair '
alias gra='git commit --amend --reset-author --no-edit'
alias gco='git checkout'
alias hangon='git stash save -u'
alias gsp='git stash pop'
alias grc='git rebase --continue'
alias gclean='git clean -df'
alias gup='gco main && gpr && gco -'
alias unwip='git reset HEAD~'
alias unroll='git reset HEAD~ --hard'
alias gpfwl='git push --force-with-lease'
alias glt='git describe --tags --abbrev=0'
alias unroll='unwip && git checkout . && git clean -df'
alias rspec_units='rspec --exclude-pattern "**/features/*_spec.rb"'
alias awsume='. awsume sso;. awsume' 
alias gprune=$'git branch --merged main | grep -v \'^[ *]*main$\' | xargs git branch -d'
alias remove_branches='git branch | grep -v "master" | xargs git branch -D'
alias fsb='~/fsb.sh'
alias fshow='~/fshow.sh'

# Tmux
# Attaches tmux to a session (example: ta portal)
alias ta='tmux attach -t'
# Creates a new session
alias tn='tmux new-session -s '
# Kill session
alias tk='tmux kill-session -t '
# Lists all ongoing sessions
alias tl='tmux list-sessions'
# Detach from session
alias td='tmux detach'
# Tmux Clear pane
alias tc='clear; tmux clear-history; clear'

alias brewup="brew update && brew upgrade && brew cleanup && brew autoremove"
alias bcu="brew cu -a --cleanup"
alias bcuall="brew upgrade --cask --greedy"

alias cd="z"
alias cdd="z -"
#  Python uv and ruff alias
alias uvinit="uv init"        # プロジェクト初期化
alias uvpin="uv python pin"   # pythonバージョン指定
alias uvlock="uv python lock" # pythonバージョン指定
alias uvunlock="uv python unlock" # python バージョン開放
alias uvrun="uv run python"   # python実行 (uvrun pythonファイルｊ)
alias uvadd="uv add"          # package install (uvadd package名)
alias uvremove="uv remove"    # package uninstall (uvremove package名)
alias uvxinit="uvx init"
# ruff(uv)
alias uvruff="uv run ruff check && uv run ruff check --fix"

# local LLM setup
alias ol-start="ollama serve --idle-timeout 600"    # 60分間の間に終了しない
alias ol-update="ollama list | tail -n +2 | tr -s ' ' | cut -d ' ' -f1 | xargs -n1 ollama pull"
#HISTTIMEFORMAT='%Y/%m/%d %H:%M:%S ' alias ol-chat="ollama run $(cat ~/.config/ollama/config.yaml)"
#
# Command completion
HISTTIMEFORMAT='%Y/%m/%d %H:%M:%S '
alias h="history -n 1000 | fzf --tac -i --no-sort -n 1 -m --tiebreak=index | awk '{print \$2}' | xargs -I{} bat {}"
