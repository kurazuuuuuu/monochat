# Change: MonoChatのコア機能を追加

## Why
MonoChatは、完全モノクロデザインの匿名掲示板アプリケーションです。ユーザーがパスワードのみで認証し、自動生成されたユーザー名で投稿できるシンプルな掲示板システムが必要です。本変更提案は、アプリケーション全体のコア機能を定義し、実装の基礎を確立します。

## What Changes
- **認証システム (auth)**: パスワードのみを使用した匿名認証、UUID/ユーザー名の自動生成、JWT認証
- **掲示板管理 (space-management)**: Space(掲示板)の作成、一覧表示、名前の自動生成
- **メッセージング (messaging)**: メッセージ投稿、取得、5秒のレート制限
- **UIデザイン (ui-design)**: 完全モノクロデザイン、DotGothic16フォント、Tabler Iconsの使用
- **データモデル (data-model)**: Users, Spaces, Messagesテーブルの定義とUUID使用

## Impact
- **影響を受けるスペック**:
  - auth (新規作成)
  - space-management (新規作成)
  - messaging (新規作成)
  - ui-design (新規作成)
  - data-model (新規作成)

- **影響を受けるコード**:
  - モデル: User, Space, Message (新規作成)
  - コントローラー: AuthController, SpacesController, MessagesController (新規作成)
  - ビュー: Login, Home, Space画面 (新規作成)
  - データベース: マイグレーションファイル (新規作成)

- **破壊的変更**: なし (初期実装のため)

## Dependencies
- なし (初期実装のため独立した変更)

## Migration Path
初期実装のため、マイグレーションパスは不要です。データベースマイグレーションを実行し、アプリケーションを起動すれば動作します。
