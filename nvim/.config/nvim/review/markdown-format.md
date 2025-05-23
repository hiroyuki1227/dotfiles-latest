Markdown記述・書き方（見出し・表・リンク・画像・文字色など）</summary

# Markdown記述・書き方（見出し・表・リンク・画像・文字色など）

**Markdown**（マークダウン）とはMarkdown(マークダウン)とは、「# 見出し」「\* リスト」など、シンプルな書き方で文書構造を明示でき、装飾されたHTML文書に変換できる軽量マークアップ言語です。このページでは、Markdown記法でよく使う「見出し・テーブル表・リンク・画像・文字色・強調・箇条書き」などの書き方をまとめています。

## 見出し

行頭に**「#」**をつけると、見出し形式になります。「#」の数が見出しレベルです。

入力例 表示結果

### 記述例

```
# 見出し１
## 見出し２
### 見出し３
#### 見出し４
##### 見出し５
###### 見出し６
```

### _結果_

# 見出し１

## 見出し２

### 見出し３

#### 見出し４

##### 見出し５

###### 見出し６

## 箇条書きリスト

ハイフン、プラス、アスタリスクのいずれかで箇条書きリストを記述可能※半角スペースを一ついれる。

### 記述例

```
- リスト1
    - ネスト リスト1_1
        - ネスト リスト1_1_1
        - ネスト リスト1_1_2
    - ネスト リスト1_2
- リスト2
- リスト3
```

### 結果

- リスト1
  - ネスト リスト1_1
    - ネスト リスト1_1_1
    - ネスト リスト1_1_2
  - ネスト リスト1_2
- リスト2
- リスト3

## 番号付きリスト

数値+半角ドットで番号付きリストを記述可能。番号の内容は何でもいい。実際に表示される際に適切な番号で表示される。そのため、一般的にはすべて 1. 内容 で記載すると変更に強く楽です。※数値+半角ドットと箇条書きの項目の間には半角スペースを1つ入れること

### 記述例

```
1. 番号付きリスト1
    1. 番号付きリスト1_1
    2. 番号付きリスト1_2
2. 番号付きリスト2
3. 番号付きリスト3

```

### 結果

1. 番号付きリスト1
   1. 番号付きリスト1_1
   2. 番号付きリスト1_2
2. 番号付きリスト2
3. 番号付きリスト3

## 引用

### 記述例

```
> お世話になります。xxxです。
>
> ご連絡いただいた、バグの件ですが、仕様です。

```

### 結果

> お世話になります。xxxです。
>
> ご連絡いただいた、バグの件ですが、仕様です。

## 太字・斜体・訂正線・下線

\*\* または \_\_ によって囲まれた文字列は「太字」になります。

### 記述例

```

- または * によって囲まれた文字列は「斜体」になります。
  ~~ で囲まれた文字は「訂正線（取り消し線）」になります。
  <u></u> で囲まれた文字は「下線」になります。
  入力例 表示結果
  これは **太字** です。
  これは **太字** です。
  これは *斜体* です。
  これは *斜体\_ です。
  これは ~~訂正線~~です。
  これは<u>下線</u>です。
  これは色を<span style="color:blue;">青色</span>です。

```

### 結果

- または _によって囲まれた文字列は「斜体」になります。~~ で囲まれた文字は「訂正線（取り消し線）」になります。 <u></u>
  で囲まれた文字は「下線」になります。入力例 表示結果これは **太字** です。これは **太字** です。これは _斜体_
  です。これは_斜体\_ です。これは
  ~~訂正線~~です。これ<u>下線</u>です。 これは色を<span style="color:blue;">青色</span>です。

[表示テキスト](URL) でURLリンクになります。

## code（コードブロック/インラインコード）

`で囲まれた文字は「インラインコード」になります。

"````"で囲まれた文字はコードブロックになります。 入力例 表示結果 これは `code` です

```typescript {filename="test.tsx"}
void hello();
{
  console.log("Hello World!");
}
```

```python
print("Hello World!")
```

```lua {filename="render-markdown.lua"}
return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  }
}
```

## テキストカラー（文字の色）

Markdown記法では、テキストカラーの変更は対応しておりません。文字色を変えたい場合は、以下のようにHTMLタグを記入すると変更できます。

入力例 表示結果これは<span style="color: red; ">赤文字</span>です

リストチェックリスト

```
行頭に - [ ] - [x] を付けると、チェックリストになります。

- [ ] これからやるタスク
- [x] 完了したタスク
```

入力例 表示結果

- [ ] これからやるタスク
- [x] 完了したタスク

［☺］ボタン、または :emoji:で 絵文字が書けます。オリジナルの絵文字を作成することもできます。参考：カスタム絵文字を追加・確認・削除する

入力例 表示結果絵文字もかんたん

いいね:smile: :+1:

## アコーディオン（折りたたみ）表示

文章を折りたたみできます。※アコーディオンのタイトルに、見出しやリンクを指定することはできません。

入力例 表示結果

<details>
<summary>タイトル</summary>

内容をここに記載する

</details>

## ファイル挿入

![代替テキスト](URL) でファイルが表示されます。詳しくは「ファイルをページ内に埋め込む・添付する」をご参照ください。

入力例 表示結果

```
![フクロウ](https://notepm.jp/build/assets/apple-touch-icon-120x120-2ee67c72.png) NotePMロゴ（正方形）.png
```

![フクロウ](https://notepm.jp/build/assets/apple-touch-icon-120x120-2ee67c72.png) NotePMロゴ（正方形）.png

## 水平線（罫線）

３つ以上の - \* \_ だけを入力した行は水平線（罫線）になります。

入力例 表示結果

```
罫線の定義
---
```

---

---

## 注釈

文中に注釈を入れることができます。

入力例 表示結果テキスト[^1]

[^1]: 注釈の内容

テキスト[^1] と [^1]:注釈の内容の行間は1行以上開けてください。 [^1]: のあとには半角スペースを入れてください。

PlantUML記法PlantUML記法でシーケンス図、コンポーネント図などのUMLを描画できます。コードブロック記法に uml ラベルで PlantUML記法になります。

```uml
Alice -> Bob: Authentication Request
Bob --> Alice: Authentication Response

Alice -> Bob: Another authentication Request
Alice <-- Bob: another authentication Response
```

数式コードブロックの言語指定に math を指定することで、TeX記法を用いて数式を描画できます。

## インライン

```
`$hoge = 1`
`.md`
```

### 結果

`$hoge = 1` `.md`

## テーブル記法

```
| Left align | Right align | Center align |
|:-----------|------------:|:------------:|
| This       |        This |     This     |
| column     |      column |    column    |
| will       |        will |     will     |
| be         |          be |      be      |
| left       |       right |    center    |
| aligned    |     aligned |   aligned    |
```

### 結果

| Left align | Right align | Center align |
| :--------- | ----------: | :----------: |
| This       |        This |     This     |
| column     |      column |    column    |
| will       |        will |     will     |
| be         |          be |      be      |
| left       |       right |    center    |
| aligned    |     aligned |   aligned    |

### Note

```m
> [!NOTE]
> A regular note
> With a second paragraph
```

> [!NOTE] A regular note With a second paragraph

```
> [!TODO]
> Todo
```

> [!TODO] Todo

```
> [!IMPORTANT]
> Important

```

> [!IMPORTANT] Important

```
> [!WARNING]
> Warning
```

> [!WARNING] Warning

```
> [!CAUTION]
> Caution
```

> [!CAUTION] Caution

```
> [!HINT]
> Hint
```

> [!HINT] Hint

```
> [!TIP]
> Tip
```

> [!TIP] Tip

```
> [!EXAMPLE]
```

> [!EXAMPLE]

### End

# Reference

# SetText 1

## SetText 2

# Setext 3

</details>

### 水平線

```md
---
---

---

---
```

## 結果

---

---

---

---

- [ ] List 1
- [x] List 2
