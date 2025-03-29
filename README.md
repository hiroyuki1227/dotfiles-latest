# dotfiles

## stow setup

```bash

brew install stow

git clone  https://github.com/hiroyuki1227/dotfiles-latest.git ~/dotfiles

cd dotfiles
stow -v nvim zsh alacritty kitty lazygit  scripts tmux wezterm hammmerspoon

dotfileがルートと.config配下にリンクが貼られる
```

### 削除する場合

```
stow -vD nvim zsh alacritty kitty lazygit  scripts tmux wezterm hammmerspoon
```

## fzf (Fuzzy Finder)

```bash
fzf is a general-purpose command-line fuzzy finder

function pkill() {
ps aux | fzf --height 40% --layout=reverse --prompt="Select process to kill: " | awk '{print $2}' | xargs -r sudo kill

}

```

; End of file
