# Project Context

## Purpose
MonoChatは、完全モノクロデザインの匿名掲示板アプリケーションです。ユーザーはパスワードのみで認証し、自動生成されたユーザー名で投稿します。シンプルで直感的なUIを提供し、ユーザー間のリアルタイムコミュニケーションを実現します。

## Tech Stack
- **Backend**: Ruby on Rails
- **Database**: SQLite (開発環境)
- **Frontend**: Rails標準のビューレイヤー (Hotwire/Turbo推奨)
- **Authentication**: bcrypt (パスワードハッシュ化)、JWT (トークン認証)
- **Version Management**: mise (Ruby)

## Project Conventions

### Code Style
- Ruby: Rails標準のコーディング規約に準拠
- インデント: スペース2つ
- 命名規則: スネークケース (Ruby/Rails)、キャメルケース (JavaScript)

### Architecture Patterns
- MVC アーキテクチャ (Rails標準)
- RESTful API設計
- データベース駆動設計 (RailsのActive Recordを活用)
- UUID使用 (全エンティティの外部識別子)

### Testing Strategy
- Rails標準のテストフレームワーク (Minitest or RSpec)
- モデル、コントローラー、統合テストを含む

### Git Workflow
- メインブランチ: `main`
- コミットメッセージ: 簡潔で明確な日本語/英語
- プルリクエスト: レビュー後にマージ

## Domain Context

### 用語定義
- **Login**: ユーザー認証画面
- **Home**: ホーム画面 (掲示板一覧)
- **Space**: 掲示板 (個別のチャットルーム)
- **Message**: 投稿メッセージ

### 認証の仕組み
- ユーザーはパスワードのみで認証
- ユーザー名は自動生成され、ユーザーは選択できない
- UUIDはブラウザに保存され、再ログインに使用
- JWTトークンでセッション管理

### デザイン制約
- 全UI要素はモノクロ (白・黒・グレー)
- フォント: DotGothic16 (Google Fonts)
- アイコン: Tabler Icons
- 匿名掲示板の雰囲気を重視

## Important Constraints
- 全てモノクロデザイン (色は使用しない)
- ユーザー名は自動生成のみ (ユーザーによる選択不可)
- パスワードのみでの認証 (メールアドレス不要)
- メッセージ投稿には5秒のレート制限

## External Dependencies
- Google Fonts (DotGothic16)
- Tabler Icons
- bcrypt (パスワードハッシュ化)
- JWT (JSON Web Token)
