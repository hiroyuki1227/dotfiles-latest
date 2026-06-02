---
title: "Alfred信者だった私が今更だけど「Raycast」を導入して、その標準機能に感動した話。"
source: "https://zenn.dev/kobakichi/articles/raycast-started"
author:
  - "[[Zenn]]"
published: 2026-01-25
created: 2026-02-07
description:
tags:
  - "clippings"
---
4

1[tech](https://zenn.dev/tech-or-idea)

## 結論：Raycastを入れると、これだけのアプリが不要になる

最初に結論から言います。  
長年愛用していたAlfred（無料版）からRaycastに乗り換えると、以下のアプリやツールが不要になります。

1. **Alfred** （ランチャー）
2. **Clipy** （クリップボード履歴）
3. **Magnet / BetterSnapTool** （ウィンドウ管理）
4. **TextExpander / ユーザー辞書** （スニペット）
5. **ブラウザのブックマークバー** （Quicklinksで代用）

特筆すべきは、これらが「 **拡張機能（Store）のインストール不要** 」かつ「 **無料の標準機能（Built-in）** 」だけで完結する点です。

社用PCなどで「勝手にツールを入れられない」「セキュリティ制限が厳しい」という環境でも、Raycast本体さえ入れば生産性が爆上がりします。

## はじめに

某IT推進企業でAWSインフラエンジニアとして働いているkobakichiです。  
普段はTerraform、Ansibleを使ってインフラ構築、保守を担当しています。

Macのランチャーといえば長らく **Alfred一択** でしたが、Raycastを試しに入れてみた結果無料でもかなり便利に使えることがわかりました。  
今回は、Alfredユーザーの視点から特に感動した **標準機能** に絞って紹介します。

詳細な設定方法は [参考記事](https://zenn.dev/kobakichi/articles/#%E5%8F%82%E8%80%83%E8%A8%98%E4%BA%8B) をご覧ください。

## インストール方法

Macであればhomebrew経由で入れることができます。

```
brew install --cask raycast
```

## 拡張機能なしで使える「標準機能」神6選

Storeから何もダウンロードしなくてOKです。

### 1\. Clipboard History（クリップボード履歴）

AlfredではPowerpack（有料）の機能ですが、Raycastなら無料・標準です。

- **起動:**`Clipboard History`
- メリット
	- プレビューが見やすい。
	- `cmd + k` で添付方法を選択可能。
	- プレーンテキストで添付したい場合は `Paste Formatted to [app]` を選択

### 2\. Window Management（ウィンドウ整理）

Alfredには標準ではない機能です。Raycastなら、Magnet等のアプリが不要になります。  
キーボードだけでウィンドウを整理できます。

- `Left Half` / `Right Half`: 左右分割
- `Maximize`: 最大化
- `Almost Maximize`: 画面端に少し余白を残して最大化

### 3\. Quicklinks（自分専用ショートカット）

Alfredの「Custom Web Search」やブラウザのブックマークの互換です。  
よく使うURLやページを登録して、キーワード一発で呼び出せます。

- **設定:**`Create Quicklink`
- **活用例:**
	- 毎日の「日報スプレッドシート」を登録して `nippo` で開く。
	- 社内ポータルの検索URLを登録して、Raycastから直接検索する。
	- 「 **このリンクはChromeじゃなくてfirefoxで開く** 」というブラウザ指定も可能。

### 4\. Snippets（スニペット）

これもAlfredではPowerpack必須の機能です。  
よく使う定型文やメールアドレスを登録して、短いキーワードで展開できます。

- **設定:**`Create Snippet`
- **使い方:**`!mail` と打つだけで `myname@example.com` に置換。

**⚠️ 設定のコツ**

- キーワードを単に `mail` などの英単語にしてしまうと、文章中で「 **gmail** 」と打った瞬間に勝手に展開されて事故ります。
- `!mail` や`;mail` のように、「 **頭に記号をつける** 」のが鉄則です。私は全てのキーワードの頭に `!` をつけるルールにしています。

### 5\. Calculator & Converter（計算・変換）

Alfredでも計算はできますが、Raycastは「 **単位変換** 」や「 **通貨換算** 」も自然言語でいけます。

- `100usd` → 今のレートで日本円を表示
- `today` → 今日の日付を表示（202X-XX-XX）
- `1980 * 1.1` → 消費税計算

### 6\. Search Screenshots（スクショ検索）

「さっき撮ったスクショ、デスクトップのどこいった？」問題が解決します。  
直近のスクリーンショットだけをリスト表示してくれる機能です。

## 番外編：人によっては刺さる機能

私は今のところあまり使っていませんが、Raycast独自のユニークな機能としてこんなものもあります。

### Search Menu Items（メニューバー検索）

「今開いているアプリのメニューバー（File, Edit...）」の中身を検索して実行できる機能です。  
ExcelやPhotoshopなど、 **メニュー階層が深くて複雑なアプリ** を多用する人には便利かもしれません。

- 使い方は `Search Menu Items` と打つだけ。
- 私はショートカットキーを覚えてしまう派なので出番は少ないですが、マウス操作を極限まで減らしたい人には良さそうです。

## おわりに

Alfredは素晴らしいアプリですし、Workflowの自由度は凄まじいです。  
しかし、「 **設定なし・無料・標準機能** 」だけでここまで完成されているRaycastはとても素晴らしいと感じました。

「Alfredの有料版までは手が出ないけど、もっと便利にしたい」  
「ClipyやMagnetなど、常駐アプリを減らしたい」  
「リンクを開く際にchromeやfirefoxなどブラウザを指定したい」  
という方はぜひ一度試してみてください。

## 参考記事

[GitHubで編集を提案](https://github.com/kobakichi/kobakichi-zenn-contents/blob/main/articles/raycast-started.md)

4

1

### Discussion

![](https://static.zenn.studio/images/drawing/discussion.png)

ログインするとコメントできます