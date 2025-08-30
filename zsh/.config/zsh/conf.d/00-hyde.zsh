#!/usr/bin/env zsh

#! ██████╗░░█████╗░  ███╗░░██╗░█████╗░████████╗  ███████╗██████╗░██╗████████╗
#! ██╔══██╗██╔══██╗  ████╗░██║██╔══██╗╚══██╔══╝  ██╔════╝██╔══██╗██║╚══██╔══╝
#! ██║░░██║██║░░██║  ██╔██╗██║██║░░██║░░░██║░░░  █████╗░░██║░░██║██║░░░██║░░░
#! ██║░░██║██║░░██║  ██║╚████║██║░░██║░░░██║░░░  ██╔══╝░░██║░░██║██║░░░██║░░░
#! ██████╔╝╚█████╔╝  ██║░╚███║╚█████╔╝░░░██║░░░  ███████╗██████╔╝██║░░░██║░░░
#! ╚═════╝░░╚════╝░  ╚═╝░░╚══╝░╚════╝░░░░╚═╝░░░  ╚══════╝╚═════╝░╚═╝░░░╚═╝░░░

# Sources vital global environment variables and configurations // Users are encouraged to use ./user.zsh for customization
# shellcheck disable=SC1091

if ! . "$HOME/.config/zsh/conf.d/hyde/env.zsh"; then
    echo "Error: Could not source $HOME/.config/zsh/conf.d/hyde/env.zsh"
    return 1
fi

if [[ $- == *i* ]] && [ -f "$HOME/.config/zsh/conf.d/hyde/terminal.zsh" ]; then
    . "$HOME/.config/zsh/conf.d/hyde/terminal.zsh" || echo "Error: Could not source $HOME/.config/zsh/conf.d/hyde/terminal.zsh"
fi
