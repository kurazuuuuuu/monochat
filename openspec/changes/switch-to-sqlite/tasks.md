# Implementation Tasks

## 1. 依存関係の更新
- [x] 1.1 `Gemfile`から`pg` gemを削除
- [x] 1.2 `Gemfile`に`sqlite3` gemを追加（必要に応じて）
- [x] 1.3 `bundle install`を実行して依存関係を更新

## 2. データベース設定の変更
- [x] 2.1 `config/database.yml`をSQLite用の設定に更新
  - development環境をSQLiteに変更
  - test環境をSQLiteに変更
  - production環境の設定を検討（必要に応じて）
- [x] 2.2 データベース接続プール設定をSQLiteに最適化

## 3. マイグレーションの修正
- [x] 3.1 UUID拡張機能を有効化するマイグレーション（`EnableUuidExtension`など）を削除または無効化
- [x] 3.2 UUID型カラムを文字列型（string/varchar）に変更
  - `users.user_uuid`を`:uuid`から`:string`に変更
  - `spaces.space_uuid`を`:uuid`から`:string`に変更
  - `messages.message_uuid`を`:uuid`から`:string`に変更
  - `messages.sender_uuid`を`:uuid`から`:string`に変更
  - `messages.space_uuid`を`:uuid`から`:string`に変更
- [x] 3.3 インデックス定義が文字列型UUIDで正しく動作することを確認

## 4. モデルの調整
- [x] 4.1 UUIDカラムのバリデーションを確認（文字列型として正しく動作するか）
- [x] 4.2 UUID生成ロジックが`SecureRandom.uuid`を使用していることを確認
- [x] 4.3 外部キー参照が文字列型UUIDで正しく動作することを確認

## 5. データベースの再構築
- [x] 5.1 既存のPostgreSQLデータベースをドロップ（必要に応じて）
- [x] 5.2 SQLiteデータベースを作成 (`rails db:create`)
- [x] 5.3 マイグレーションを実行 (`rails db:migrate`)
- [x] 5.4 テストデータベースをセットアップ (`rails db:test:prepare`)

## 6. 検証
- [x] 6.1 開発サーバーが正常に起動することを確認 (`rails s`)
- [x] 6.2 データベース接続が正常に動作することを確認
- [x] 6.3 テストスイートを実行して全てパスすることを確認（該当する場合）
- [x] 6.4 基本的なCRUD操作が動作することを手動確認
  - User作成
  - Space作成
  - Message作成

## 7. ドキュメント更新
- [x] 7.1 `README.md`にSQLite使用に関する記述を追加
- [x] 7.2 `openspec/project.md`のTech Stackセクションを更新（PostgreSQL→SQLite）
- [x] 7.3 セットアップ手順からPostgreSQLサーバー起動の記述を削除
