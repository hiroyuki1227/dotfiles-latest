# workspaces.lua 処理説明

## 1. 初期化・モジュール読み込み

```lua
local colors   = require("colors")
local settings = require("settings")
local backend  = require("items.spaces_aerospace")
```

| モジュール | 役割                                                      |
| ---------- | --------------------------------------------------------- |
| `colors`   | テーマカラーの定義                                        |
| `settings` | フォントなどの設定                                        |
| `backend`  | `spaces_aerospace.lua` — コマンド文字列・イベント名を提供 |

---

## 2. スロットの事前生成 — `build_pool()`

sketchybar のアイテムは**起動時に全て作り置き**しておき、後から表示/非表示を切り替えます。動的に追加/削除するとちらつくためです。

```
slots[1]
 ├─ num        "aerospace.ws.1.num"      ← ワークスペース番号
 ├─ apps[1]    "aerospace.ws.1.app.1"    ┐
 ├─ apps[2]    "aerospace.ws.1.app.2"    ├─ アプリアイコン（最大12個）
 │   ...                                 ┘
 └─ bracket    "aerospace.ws.1.bracket"  ← 全体を囲む背景カプセル
```

これを `MAX_WS`（10）分繰り返します。

---

## 3. クリック処理 — `make_num()` 内

```lua
item:subscribe("mouse.clicked", function(env)
    if env.BUTTON ~= "right" then
        sbar.exec(backend.click_cmd(i))
        -- 展開すると: aerospace workspace 1
    end
end)
```

- **左クリック** — そのワークスペースに切り替え
- **右クリック** — 何もしない（AeroSpace にはワークスペース作成 API がないため）

---

## 4. AeroSpace から状態取得 — `fetch_layout()`

`backend.fetch_state_cmd()` が返すコマンドを実行します。

```bash
aerospace list-windows --all --format "%{workspace}|%{app-name}"
echo '---'
aerospace list-workspaces --focused
```

### 出力例

```
1|Safari
1|Terminal
2|Finder
---
1
```

### パース処理（3段階）

**① `---` より上 → ウィンドウ一覧**

```lua
local ws, app = line:match("^(.-)|(.+)$")
-- ws="1", app="Safari" のように分解
```

**② `---` より下 → フォーカス中ワークスペース**

```lua
focused = trim(line)  -- "1"
```

**③ layout テーブルに変換**

```lua
layout = {
    [1] = { apps = {"Safari", "Terminal"}, has_focus = true  },
    [2] = { apps = {"Finder"},             has_focus = false },
}
```

> アプリがなくてもフォーカス中の WS は空エントリとして追加します（番号だけ表示するため）。

---

## 5. 描画 — `paint_slot()` / `hide_slot()`

`layout` テーブルを元に各スロットを更新します。

| 状態                               | 番号の色 | アイコン scale | bracket 背景 |
| ---------------------------------- | -------- | -------------- | ------------ |
| アクティブ（`has_focus = true`）   | 白       | 1.0（等倍）    | 表示         |
| 非アクティブ                       | グレー   | 0.80（縮小）   | 非表示       |
| 未使用スロット（`layout[i]` なし） | 非表示   | 非表示         | 非表示       |

---

## 6. 更新トリガー — `watcher`

以下のイベントで `refresh()` を呼び出します。

| イベント                     | 発火タイミング                                   |
| ---------------------------- | ------------------------------------------------ |
| `aerospace_workspace_change` | WS 切り替え時（`aerospace.toml` のトリガー経由） |
| `front_app_switched`         | 前面アプリ変更時                                 |
| `system_woke`                | スリープ復帰時                                   |
| `forced`                     | sketchybar 再起動時                              |

`backend.events` にイベントが追加された場合も自動的に購読されます。

---

## 7. 全体の流れ

```
sketchybar 起動
    │
    ├─ sbar.delay(0.5秒)
    │       │
    │       ├─ build_pool()
    │       │   └─ slots[1〜10] を生成（全て非表示）
    │       │
    │       ├─ watcher 登録
    │       │   └─ イベント発火 → refresh()
    │       │
    │       └─ refresh()
    │               │
    │               ├─ fetch_layout()
    │               │   └─ sbar.exec(fetch_state_cmd)
    │               │       └─ 出力をパース → layout テーブル
    │               │
    │               └─ sbar.animate("circ", 30)
    │                   ├─ paint_slot() × 使用中 WS 数
    │                   └─ hide_slot()  × 未使用スロット数
    │
    └─ イベント発火のたびに refresh() を繰り返す
```

---

## 8. `spaces_aerospace.lua` との役割分担

| 責務                       | ファイル                          |
| -------------------------- | --------------------------------- |
| コマンド文字列の生成       | `spaces_aerospace.lua`（backend） |
| 購読イベント名の定義       | `spaces_aerospace.lua`（backend） |
| パース・描画・スロット管理 | `workspaces.lua`                  |

backend を差し替えるだけで他の WM（Yabai・Rift など）にも対応できる設計です。
