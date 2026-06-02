---
title: "私のRaycast の使い方"
source: "https://qiita.com/aki-y/items/99c3cd67a1e658df8d27"
author:
  - "[[aki-y]]"
published: 2025-01-04
created: 2026-02-07
description: "Raycastとは RaycastはMac向けのランチャーツールです。 ランチャーツールで有名なものはAlfredがあります。 ⌘(コマンド) + spaceで起動するSpotlightもランチャーツールです。 ショートカットキーでアプリの起動、クリップボードの履歴取得、..."
tags:
  - "clippings"
---
![](https://relay-dsp.ad-m.asia/dmp/sync/bizmatrix?pid=c3ed207b574cf11376&d=x18o8hduaj&uid=)

この記事は最終更新日から1年以上が経過しています。

## Raycastとは

RaycastはMac向けのランチャーツールです。  
ランチャーツールで有名なものは [Alfred](https://www.alfredapp.com/) があります。  
`⌘(コマンド) + space` で起動する [Spotlight](https://support.apple.com/ja-jp/guide/mac-help/mchlp1008/mac) もランチャーツールです。  
ショートカットキーでアプリの起動、クリップボードの履歴取得、リマインダーのセットなどできることは多岐に渡ります。  
公式サイト: [Raycast](https://www.raycast.com/)

## おすすめポイント

- 無料でほとんど使える
- UIがいい
- 拡張機能がある

## 無料でほとんど使える

Alfredは有料プランが34£(約6600円)からと結構高いです。  
RaycastもPro版は有料ですが、正直必要ないくらい無料プランでできることが充実しています。

## UIがいい

公式サイトでデモ画面等も見ることができますが、シンプルかつグラデーションの効いたUI でテンションが上がるデザインになっています。

## 拡張機能がある

[Store](https://www.raycast.com/store) というRaycast公式の拡張機能ストアがあり、こちらから色々な機能を追加することもできます。  
例えば、 [Authy](https://www.raycast.com/guga4ka/authy) という拡張機能ではMFAがRaycastでできます。  
[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2779963/a6015a85-386c-6d19-53db-7b766a40aef0.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2779963%2Fa6015a85-386c-6d19-53db-7b766a40aef0.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=8070e8a4c3726862fd3fb52d0f8fa7d6)  
他にも、 [Brew](https://www.raycast.com/nhojb/brew) という拡張機能があります。homebrewのインストールや検索をRaycast上で行える、というものです。  
[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2779963/39ebb12e-4aa1-e365-7d04-4aeeaa5fa304.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2779963%2F39ebb12e-4aa1-e365-7d04-4aeeaa5fa304.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=039a2da5b266014a0d9af3a23a25e16c)

## インストール方法

bash

```bash
brew install --cask raycast
```

## よく使う機能紹介

- Hotkey
- クリップボード
- Quicklink
- Calender
- Git Repos
- Raycast Note
- Confetti(おまけ)

## Hotkey

Raycastはデフォルトで、 `option + space` で起動します。  
そこをエントリポイントとして使用しますが、特によく使うものは別途ショートカットキーをつけることが可能です。

Raycastを開き、 `⌘ + ,`で設定が開きます。  
ここの `Extentions` でホットキー(ショートカットキー)の設定ができます。  
私はクリップボードを、 `option + v` で開くようにしています。  
[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2779963/bd38cc77-e15f-11ad-d203-87f97f5afe18.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2779963%2Fbd38cc77-e15f-11ad-d203-87f97f5afe18.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=000fe6ee97c22b286a3bc28a15d626e3)

## クリップボード

さまざまなものがコピーできて、プレビュー機能もあるので使いやすいです。

### テキスト

[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2779963/5844e8e2-c4bc-0b50-d26c-f0611d7296c3.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2779963%2F5844e8e2-c4bc-0b50-d26c-f0611d7296c3.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=5b558cd52ba5265e5c479bd0c7b9acad)

### カラーコード

色の確認もできます。  
[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2779963/01eb5aa7-3c58-86f2-24c4-55e37117cbd6.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2779963%2F01eb5aa7-3c58-86f2-24c4-55e37117cbd6.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=b969410586666196781301447e27b948)

### 画像

[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2779963/9a4155e6-3457-d395-04a1-38346b098e62.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2779963%2F9a4155e6-3457-d395-04a1-38346b098e62.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=3d48090b4eef7c96f80f38fa7cf0c6d9)

### リンク

OGPも表示してくれます。  
[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2779963/5fe1033f-8538-e8a0-c971-cf211f320a02.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2779963%2F5fe1033f-8538-e8a0-c971-cf211f320a02.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=4ad77d315d9ed89425066ceda9de7451)

### 補足

クリップボードはデフォルトで、7日間の保存期間ですが無料版では最大3ヶ月間保存させることもできます。  
[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2779963/bd38cc77-e15f-11ad-d203-87f97f5afe18.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2779963%2Fbd38cc77-e15f-11ad-d203-87f97f5afe18.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=000fe6ee97c22b286a3bc28a15d626e3)

## Quicklink

Quicklinkは、「Raycastから指定したURLをどのアプリケーションで開くか」を登録できる機能です。  
これがすごく便利です。  
特に使うのが、「localhost:3000を開く」、「案件で使用するプロジェクトをVScodeで開く」の2ケースです。

使い方は、Quicklinkに登録してRaycastから呼び出すだけです。

### ケース1: localhost:3000を開く

まずはRaycastで登録するので、 `Create Quicklink` を開きます。  
[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2779963/4db234b8-f200-fac0-9826-8c049cec1f95.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2779963%2F4db234b8-f200-fac0-9826-8c049cec1f95.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=13cb62e8e6936ef385a71367e46eef0f)

次に `Name` と `Link` と `Open With` に入力します。  
`Name` はRaycastで立ち上げる時に入力する名前です。入力したら、⌘ + Enterで登録します。  
[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2779963/f079d893-8c9a-8e5b-a0bf-e1dd71cef97a.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2779963%2Ff079d893-8c9a-8e5b-a0bf-e1dd71cef97a.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=85199f0f2cec313b1db8b066345c1f6e)

すると、 `Name` に登録した名前で検索すると、先ほど作成したものがサジェストされます。  
[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2779963/ea0183b4-fd7a-7faa-a553-29712c3abaf6.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2779963%2Fea0183b4-fd7a-7faa-a553-29712c3abaf6.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=4ce72937959145ada299cfc88741027f)

セレクトした状態でエンター押すと、localhost:3000に飛んでくれます。  
[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2779963/85251007-1e05-2849-daa3-376e08ebe5dd.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2779963%2F85251007-1e05-2849-daa3-376e08ebe5dd.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=205e56fabbcd90b0ebfbf3139e850185)

### ケース2: 案件で使用するプロジェクトをVScodeで開く

後述する拡張機能(Git Repos)の方を最近は使ってます。

これもかなり便利です。  
今回は、デスクトップにサンプルプロジェクトフォルダを作成しました。  
先ほどと同様に `Create Quicklink` を開きます。  
`Link` はプロジェクトフォルダへのパス、 `Open With` をVScodeにします。  
登録するときは、 `⌘ + Enter` を忘れずに。  
[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2779963/30ffaa75-09ab-92cd-15f2-defad4d22ad1.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2779963%2F30ffaa75-09ab-92cd-15f2-defad4d22ad1.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=bb0e7a6d732771dc04fad0fb67eda4e8)

そして、登録した名前で検索すると、サジェストされます。  
[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2779963/bccfcbc2-b443-7fca-3003-24413e0736cf.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2779963%2Fbccfcbc2-b443-7fca-3003-24413e0736cf.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=252a246199981ca019b967bfbf232fd6)

エンターで開くと、VScodeが立ち上がります。めちゃ便利。  
[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2779963/f5a9d30e-2147-56d5-33a1-1c41e0c3bce8.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2779963%2Ff5a9d30e-2147-56d5-33a1-1c41e0c3bce8.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=44f749a10ef4a0359282903c4c3a1c0a)

## Calender

[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2779963/544a9390-96b6-6dd1-372d-e732a2b9811f.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2779963%2F544a9390-96b6-6dd1-372d-e732a2b9811f.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=eea18b7a91908cc355f9434fcef76393)

Google カレンダーと連携した機能です。  
カレンダーに登録した予定が近づくと、画像のようにサジェストしてくれるようになります。  
Meet やZoom, Teams がカレンダーに登録されていると、この予定をエンターするだけで勝手に開いてくれるのもとても便利なポイントです！

## Git Repos

[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2779963/002b28af-13d9-e337-66f4-8ae07a5a28b8.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2779963%2F002b28af-13d9-e337-66f4-8ae07a5a28b8.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=f8fe3dd3c0480e2f93c23a758676755b)

拡張機能の紹介です。  
以前までは、Quicklink を主に使っていましたがgit 追跡しているプロジェクトは基本的にこれを使ってます。  
Quicklink のように個別で登録が不要なので、初期設定さえ行なってしまうと簡単にVSCode で開くことができるのでとても重宝してます。

## Raycast Note

[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2779963/ac7edeb2-306b-6c96-5ddf-4a38f7f410c3.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2779963%2Fac7edeb2-306b-6c96-5ddf-4a38f7f410c3.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=ed8030ad5504e8e9b065e66929e4538b)

最近リリースされた機能です。  
画面の最前部にメモ用のウィンドウを浮かせる機能です。  
以前まではFloating Note という機能として提供されていましたが、画像のようにマークダウン記法への対応や複数メモファイルの登録など多機能になったタイミングでRaycast Note へとリブランディングされました。  
ちょっとしたメモを取りたい時にとても便利な機能です。

## Confetti(おまけ)

ちょっとした遊び心の機能です。  
Confetti と入力するとアニメーションが動きます。ちなみに紙吹雪という意味みたいです。  
画面共有したときの話題作りやエラー解決時とかにいいかもしれませんね。

[![demo.gif](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2779963%2Fe0c1d462-4435-2b17-e946-66dfb0ce2a71.gif?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=e959fe559dcbe7c3167328bc20d0192c)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2779963%2Fe0c1d462-4435-2b17-e946-66dfb0ce2a71.gif?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=e959fe559dcbe7c3167328bc20d0192c)

## 終わりに

個人的なRaycast の使い方を紹介しました。  
「Raycast Wrapped」とRaycast で検索すると、2024 年の使用レポートを確認できるのでぜひみなさんのRaycast ライフも振り返ってみてください。

↓ちなみに自分はこんな感じでした。来年はもっと使い込むぞ！  
[![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2779963/22822141-0ff6-1b6d-d478-e9d2d2ed7e8c.png)](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2779963%2F22822141-0ff6-1b6d-d478-e9d2d2ed7e8c.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=0d85ea435fc86443c52ccb37bce867aa)

[0](https://qiita.com/aki-y/items/#comments)

コメント一覧へ移動

X（Twitter）でシェアする

Facebookでシェアする

はてなブックマークに追加する

新規登録して、もっと便利にQiitaを使ってみよう

1. あなたにマッチした記事をお届けします
2. 便利な情報をあとで効率的に読み返せます
3. ダークテーマを利用できます
[ログインすると使える機能について](https://help.qiita.com/ja/articles/qiita-login-user)

[新規登録](https://qiita.com/signup?callback_action=login_or_signup&redirect_to=%2Faki-y%2Fitems%2F99c3cd67a1e658df8d27&realm=qiita) [ログイン](https://qiita.com/login?callback_action=login_or_signup&redirect_to=%2Faki-y%2Fitems%2F99c3cd67a1e658df8d27&realm=qiita)

[![aki-y](https://qiita-user-profile-images.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F2779963%2Fprofile-images%2F1685984938?ixlib=rb-4.0.0&auto=compress%2Cformat&lossless=0&w=128&s=12a851466f56a0c6da1b3c5218341f1e)](https://qiita.com/aki-y)

[

## @aki-y

](https://qiita.com/aki-y)

[RSS](https://qiita.com/aki-y/feed)## [アイレット株式会社](https://qiita.com/organizations/iret)

アイレットは、システム・アプリケーションの開発、グラフィック・UI/UXデザイン制作からインフラの構築・運用までをワンストップで提供しています。 実績・経験が豊富なデザイナーやシステムエンジニアが、あらゆる側面からお客様の課題に向き合い、お客様に寄り添ったサービスを提供しています。

[https://www.iret.co.jp/](https://www.iret.co.jp/)

[50](https://qiita.com/aki-y/items/99c3cd67a1e658df8d27/likers)

いいねしたユーザー一覧へ移動

27