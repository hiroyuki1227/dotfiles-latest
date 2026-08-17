# Design System Generator 開発プロセス

- Phase 0:
対話形式での設計判断（8項目の技術選定）
- Phase 1: 設計ドキュメント2種の作成（28タスク
・11並列グループ）
- Phase 2: 基盤構築（順次実行）
- Phase 3-4: 3エージェント並列 x
2ラウンドでの機能開発
- Phase 5: 統合時のバグ修正3件
- Phase 6: ユーザーフィードバック対応3件
- Phase 7: BYOK対応

## 概要

Claude Code を使い、**AIデザインシステムジェネレーター**を1セッションでゼロから構築した記録です。
7ステップのウィザード形式でユーザーの要望をヒアリングし、Claude APIでデザインシステム（YAML）を自動生成するWebアプリケーションです。

---

## Phase 0: 要件理解 & 設計判断

最初に `requirements.md` を読み込ませ、対話形式で技術的な設計判断を行いました。

**聞いた項目と決定内容：**

| 項目 | 選択肢 | 決定 |
|------|--------|------|
| 実装範囲 | Phase別 or 全Phase一括 | **全Phase一括** |
| 状態管理 | Redux / Zustand / Jotai | **Zustand** |
| ファイルストレージ | Vercel Blob / S3 / Cloudflare R2 | **Vercel Blob** |
| 履歴管理 | DB / localStorage | **localStorage** |
| アーキテクチャ | モノリシック / マイクロサービス | **モノリシック Next.js（App Router）** |
| UIテーマ | ライト / ダーク / 自動切替 | **ダークベース（Vercel風）** |
| カラースキーム | ブルー系 / モノクロ / カスタム | **モノクロ + Whiteアクセント** |
| デザインの方向性 | AI感あり / なし | **AI感を排除、Vercel/Figma的な洗練さ** |

**ポイント：** Claude Code に「最適なチームを組んで」と指示し、並列開発のためのエージェントチーム構成も設計させました。

---

## Phase 1: 設計ドキュメント作成

コードを書く前に、2つの設計ドキュメントを作成・レビューしました。

### 1. デザインドキュメント（`docs/plans/2026-02-19-dsg-design.md`）
- アーキテクチャ & 技術スタック
- ディレクトリ構造
- データフロー（Zustandストア設計）
- ビジュアルデザイン仕様（カラーコード、フォント、スペーシング）
- 画面フロー & エラーハンドリング方針

### 2. 実装計画（`docs/plans/2026-02-19-dsg-implementation.md`）
- **28タスク**に分解
- **11の並列実行可能グループ**に整理
- 各タスクにファイル一覧・ステップ・コード例を記載

**ポイント：** 実装計画は「Claude Code のエージェントがそのまま実行できる粒度」で書かれています。

---

## Phase 2: 基盤構築（タスク1〜4、順次実行）

基盤部分は依存関係があるため、1つのエージェントで順次実行しました。

```
Task 1: プロジェクト初期化（Next.js + Tailwind + shadcn/ui + Geist font）
Task 2: TypeScript型定義（DesignSystem, FormData, HistoryEntry）
Task 3: Zustandストア（formStore, designSystemStore, historyStore）
Task 4: レイアウト & ヘッダー（ダークテーマ、ドットパターン背景）
```

---

## Phase 3: 機能開発（3エージェント並列）

基盤完成後、**3つのエージェントを並列起動**して独立した機能を同時開発しました。

```
[Agent A: form-builder]     → ステップフォーム（7ステップ）+ バリデーション
[Agent B: api-builder]      → Claude APIプロンプト + ストリーミングAPI + 生成UI
[Agent C: display-builder]  → カラーパレット + タイポグラフィ + スペーシング表示
```

### Agent A が作ったもの
- `ProjectTypeStep` → `IndustryStep` → `ImpressionStep` → `ColorStep` → `FontStep` → `DensityStep` → `BrandDescriptionStep`
- `StepContainer`（AnimatePresence によるステップ遷移アニメーション）
- `StepProgress`（7ステップの進捗インジケーター）
- `FileUploadArea`（ドラッグ&ドロップ、Base64変換）

### Agent B が作ったもの
- `prompts.ts`（システムプロンプト + 生成プロンプト構築）
- `claude.ts`（Anthropic SDK ストリーミングクライアント）
- `/api/generate` & `/api/regenerate`（POST エンドポイント）
- `GenerationStream`（リアルタイム生成UI、パルスアニメーション付き）

### Agent C が作ったもの
- `ColorPalette` / `ColorSwatch`
- `TypographyShowcase` / `SpacingShowcase` / `BorderShadowShowcase`
- `ComponentShowcase`（ボタン・カード・インプットのライブレンダリング）
- `DesignSystemOverview`（全コンポーネント統合表示）

---

## Phase 4: ページ & プレビュー（3エージェント並列）

```
[Agent D: pages-builder]    → 生成ページ + 結果ページ + エクスポートページ + 履歴パネル
[Agent E: preview-builder]  → Webサイトプレビュー（iframe + CSSカスタムプロパティ注入）
[Agent F: editor-builder]   → インラインエディター（カラー/タイポグラフィ/スペーシング）+ AI再生成
```

---

## Phase 5: 統合 & バグ修正

並列開発後、統合時に発生した問題を順次修正しました。

### 修正1: Claude API media_type エラー
- **原因：** SVG/PDF ファイルを `image` ブロックとして送信していた
- **対処：** `SUPPORTED_IMAGE_TYPES` セットでフィルタリング、非対応ファイルはテキスト参照に変換

### 修正2: JSON パースエラー
- **原因：** Claude がJSONレスポンスを ` ```json ``` ` で囲んで返す場合がある
- **対処：** パース前にマークダウンフェンスを除去する処理を追加

### 修正3: import方式の不一致
- **原因：** `export default` を名前付きインポートしていた
- **対処：** `import WebsitePreview from ...` に修正

---

## Phase 6: ユーザーフィードバック対応

実際に動作確認してもらい、以下の3点を修正しました。

### フィードバック1: プレビューテンプレートの不足
- **指摘：** ECサイトを選んだのにプレビューがLP/SaaS/コーポレートしかない
- **対処：** EC/ポートフォリオ/ブログの3テンプレートを追加（計6種）、projectType に連動して初期表示を自動選択

### フィードバック2: テンプレートの絵文字禁止
- **指摘：** プレビューに絵文字が多用されている
- **対処：** 全15箇所の絵文字HTMLエンティティをインラインSVGアイコン（Lucide風）に置換

### フィードバック3: 日本語入力（IME）の問題
- **指摘：** Enterキーで日本語入力中に送信されてしまう
- **対処：** `compositionstart`/`compositionend` イベントでIME状態を検知、Cmd+Enter でのみ送信に変更

---

## Phase 7: BYOK（Bring Your Own Key）対応

サーバー側にAPIキーを持たず、ユーザー自身のClaude APIキーを使う方式に変更しました。

- `apiKeyStore`（sessionStorage永続化）を追加
- ヘッダーにAPIキー入力UIを追加
- API RouteでリクエストヘッダーからAPIキーを取得する方式に変更

---

## 開発の流れまとめ

```
要件理解 → 設計判断（対話）→ 設計ドキュメント作成
    ↓
基盤構築（順次）
    ↓
機能開発（3エージェント並列）→ 統合
    ↓
ページ & プレビュー（3エージェント並列）→ 統合
    ↓
バグ修正 → ユーザーフィードバック対応 → BYOK対応
```

### 最終的なコミット履歴（30コミット）

```
# Phase 1: 設計
Add design document for Design System Generator
Add comprehensive implementation plan for DSG

# Phase 2: 基盤
feat: initialize Next.js project with dark theme and dependencies
feat: add TypeScript type definitions for design system and form
feat: add Zustand stores for form, design system, and history
feat: add app layout with header and dot pattern background

# Phase 3: 機能開発（並列）
feat: add step form container with progress indicator
feat: add step form steps 1-3 (project type, industry, impressions)
feat: add color palette display components
feat: add Claude prompt system for design generation
feat: add step form steps 4-6 (color, font, density)
feat: add typography, spacing, and border/shadow showcase
feat: add Claude API streaming generation and regeneration routes
feat: add step 7 with brand description and file upload area
feat: add component showcase and design system overview

# Phase 4: ページ & プレビュー（並列）
feat: add generation screen with streaming UI
feat: add result page with design system overview tabs
feat: add YAML export with download and clipboard copy
feat: add inline color editor with color picker
feat: add typography and spacing editors
feat: add AI regeneration input and design editor
feat: add generation history panel
feat: add CSS variable system for design system preview
feat: add website preview templates (landing, saas, corporate)
feat: add website preview component with responsive toggle
feat: integrate preview and editor into result page tabs

# Phase 5-7: 修正 & 改善
fix: filter unsupported image types before sending to Claude API
fix: strip markdown fences from Claude API JSON response
fix: IME対応・絵文字除去・テンプレート拡充の3点修正
feat: BYOK でユーザー自身のAPIキーを使用する方式に変更
fix: sessionStorage hydration mismatch による React #418 エラーを修正
```

---

## 技術スタック

| カテゴリ | 技術 |
|---------|------|
| フレームワーク | Next.js 16 (App Router) + TypeScript |
| スタイリング | Tailwind CSS v4 + shadcn/ui (New York) |
| 状態管理 | Zustand (persist middleware) |
| AI | Anthropic SDK (Claude claude-sonnet-4-5-20250929, Streaming) |
| アニメーション | Framer Motion |
| フォント | Geist Sans / Geist Mono + Noto Sans JP |
| エクスポート | js-yaml |
| ファイル保存 | Vercel Blob |
| 履歴 | localStorage（最大20件） |

---

## キーポイント

1. **設計ドキュメント先行**: コードを書く前に設計ドキュメントと実装計画を作成し、全体像を固めた
2. **エージェント並列開発**: 独立した機能を複数エージェントで同時開発し、開発速度を最大化
3. **段階的統合**: 並列開発 → 統合 → バグ修正 のサイクルを繰り返し
4. **ユーザーフィードバック駆動**: 動作確認 → フィードバック → 即修正 の高速ループ
5. **IME対応など日本語特有の課題**: 日本語入力時のEnterキー問題など、ローカライズの配慮
