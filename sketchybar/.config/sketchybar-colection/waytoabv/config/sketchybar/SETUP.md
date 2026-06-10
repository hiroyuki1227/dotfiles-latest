# IME SketchyBar 実装 — セットアップガイド

## ファイル構成

```
~/.config/sketchybar/
├── sketchybarrc          # ← ime.sh の起動を追記
├── init.lua              # ← require("items.ime") を追記
├── icons.lua             # ← icons.ime テーブルを追記
├── colors.lua            # ← colors.ime テーブルを追記
├── items/
│   └── ime.lua           # ← 新規作成 (本パッケージに含む)
└── ime.sh                # ← 新規作成 (本パッケージに含む)
```

---

## 1. ファイルのコピー

```bash
# items/ime.lua を配置
cp items/ime.lua ~/.config/sketchybar/items/ime.lua

# ime.sh を配置して実行権限を付与
cp ime.sh ~/.config/sketchybar/ime.sh
chmod +x ~/.config/sketchybar/ime.sh
```

---

## 2. icons.lua への追記

`icons_ime_snippet.lua` の内容を `return icons` の直前に追記:

```lua
-- icons.lua (既存ファイルへの追記)
icons.ime = {
  english  = "A",
  japanese = "あ",
}

return icons  -- ← 既存のreturn文
```

---

## 3. colors.lua への追記

`colors_ime_snippet.lua` の内容を `return colors` の直前に追記:

```lua
-- colors.lua (既存ファイルへの追記)
colors.ime = {
  english  = 0xff5194e4,
  japanese = 0xffec8a2b,
}

return colors  -- ← 既存のreturn文
```

---

## 4. init.lua への追記

```lua
-- init.lua (既存の require リストに追加)
require("items.spaces")
require("items.ime")    -- ← この行を追加
-- ... 他のアイテム ...
```

---

## 5. sketchybarrc への追記

`sketchybar` の起動設定ファイルに ime.sh の常駐起動を追加:

```bash
# sketchybarrc (末尾に追記)

# IME監視スクリプトをバックグラウンドで起動
# 既に起動済みのプロセスを終了してから再起動する
pkill -f "ime.sh" 2>/dev/null
"$HOME/.config/sketchybar/ime.sh" &
```

---

## 6. 動作確認

```bash
# SketchyBar を再起動
sketchybar --reload

# ログを確認 (IMEトリガーが届いているか)
log stream --predicate 'process == "sketchybar"' --level debug 2>/dev/null | grep ime

# 手動でトリガーテスト (日本語)
sketchybar --trigger ime_change INPUT_SOURCE=com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese

# 手動でトリガーテスト (英字)
sketchybar --trigger ime_change INPUT_SOURCE=com.apple.keylayout.ABC
```

---

## トラブルシューティング

### IMEが切り替わっても表示が変わらない
`ime.sh` が起動しているか確認:
```bash
pgrep -fl ime.sh
```

起動していなければ手動実行してログを確認:
```bash
~/.config/sketchybar/ime.sh
```

### `defaults read` が空を返す
macOS のバージョンによって plist のキー名が異なる場合があります:
```bash
# 現在のInput Source IDを確認するコマンド
defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources
```

`KeyboardInputSourceID` が見つからない場合は `KeyboardLayout Name` を試してください。

### AquaSKK / Google日本語入力 を使っている
`items/ime.lua` の `get_ime_display()` 関数内の判定パターンを確認してください。
上記の主要なIMEは対応済みですが、カスタムIMEの場合は以下で Input Source ID を確認:

```bash
defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources \
  | grep KeyboardInputSourceID
```

取得した ID の一部を `get_ime_display()` の `find()` に追加してください。

### クリックでのトグルが効かない
macOS のアクセシビリティ権限が必要です:
システム設定 → プライバシーとセキュリティ → アクセシビリティ → sketchybar を許可

または、クリックトグル機能を無効化してシンプルな表示専用にするには
`items/ime.lua` の `mouse.clicked` ブロックを削除してください。

---

## ポーリング間隔の調整

`ime.sh` の `sleep 0.3` を変更することで応答速度とCPU使用率のバランスを調整できます:
- `sleep 0.1` — 高速応答 (CPU使用率やや増加)
- `sleep 0.3` — デフォルト (推奨)
- `sleep 0.5` — 省電力 (切り替えに若干の遅延)
