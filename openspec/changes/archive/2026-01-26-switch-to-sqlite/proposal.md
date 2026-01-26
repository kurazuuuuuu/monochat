# Change: PostgreSQLからSQLiteへの移行

## Why
現在MonoChatはPostgreSQLを使用する設計になっていますが、開発やセットアップの簡便性を向上させるため、Rails標準の軽量データベースであるSQLiteに移行します。データベースサーバーの起動・管理が不要になり、開発体験が大幅に改善されます。パフォーマンスは考慮せず、シンプルさを最優先します。

## What Changes
- **データベースアダプタ**: PostgreSQLからSQLiteに変更
- **UUID管理**: PostgreSQL固有のUUID型から、文字列型によるUUID管理に変更
- **データベース設定**: `config/database.yml`をSQLite用に更新
- **マイグレーション**: UUID拡張機能の有効化マイグレーションを削除
- **Gemfile**: `pg` gemを削除し、`sqlite3` gemを使用

## Impact
- **影響を受けるスペック**:
  - data-model (既存スペックの修正)
  
- **影響を受けるコード**:
  - `config/database.yml` - SQLite用の設定に変更
  - `Gemfile` - データベースgemの変更
  - データベースマイグレーション - UUID拡張機能の削除
  - モデル - UUID型の扱いを調整（必要に応じて）

- **破壊的変更**: 
  - **BREAKING**: PostgreSQLからSQLiteへの移行のため、既存のPostgreSQLデータベースは使用できなくなります
  - データベースマイグレーションの再実行が必要です

## Dependencies
- `add-monochat-core-features` 変更のdata-model仕様に依存

## Migration Path
1. 既存のPostgreSQLデータベースが存在する場合、データのバックアップが必要
2. `Gemfile`を更新し、`bundle install`を実行
3. `config/database.yml`をSQLite用に更新
4. データベースマイグレーションを再実行（`rails db:migrate`）
5. 開発サーバーを再起動
