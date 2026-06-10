#!/bin/bash

# Brewのアップデート数を取得（FormulaeとCaskの両方を対象）
num_outdated=$(/bin/zsh -c "brew outdated -q | wc -l | tr -d ' \n'")

if [ "$num_outdated" -gt 0 ]; then
  # アップデートがある場合：アイコンを表示し、数値をラベルにする
  sketchybar --set homebrew icon="  " label="$num_outdated" drawing=on
else
  # アップデートがない場合：アイテムを非表示にする
  sketchybar --set homebrew drawing=off
fi
