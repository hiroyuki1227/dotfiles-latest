# [Ollama] ローカル環境でLLM推論

## Contant

- Ollamaとは？
- Ollamaの特徴
- Ollamaでサポートしている言語モデル
- 検証結果
- ライセンスOllamaの使い方Ollamaのシステム要件1．Ollamaのインストール2．インストーラーを実行Ollamaを使う際の注意点OllamaでLlama-3-ELYZA-JP-8Bを動かしてみた1．モデルダウンロード2．ファイル作成3．モデル作成4．モデル実行5．プロンプト（>>>）入力OllamaでDeepSeek-R1:1.5Bを動かしてみた1．モデルダウンロード2．モデル実行3．プロンプト入力（>>>）

## ollamaでサポートしている言語モデル

Ollamaは様々な言語モデルに対応しており、ユースケースに応じて最適なモデルを選択することが可能です。

| モデル | ユースケース +--------+---------------------- Llama 2 文章生成、要約、校正 Llama 2 チャットボット、対話型AI
Gemma 2 医療や法務のテキスト解析 Mistral 意味解析、感情分析 Moondream 2 創作、感情に基づく文章生成 Neural
Chat カスタマーサポート、音声アシスタント Starling 質問応答、検索エンジン Code
Llama コード生成、デバッグ LLaVA 画像キャプション生成、画像認識 Solar 情報検索、FAQ自動回答 DeepSeek-R1 数学、コード、推論の各タスクにおいてOpenAI-o1に匹敵
