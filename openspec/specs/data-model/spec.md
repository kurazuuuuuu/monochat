# data-model Specification

## Purpose
TBD - created by archiving change switch-to-sqlite. Update Purpose after archive.
## Requirements
### Requirement: User Model
システムは、ユーザー情報を管理するUserモデルをSHALL定義する。Userテーブルには、ID、UUID、ユーザー名、パスワードハッシュ、タイムスタンプが含まれる。UUIDは文字列型で保存される。

#### Scenario: User table schema
- **WHEN** データベースマイグレーションを実行
- **THEN** 以下のカラムを持つusersテーブルが作成される:
  - id (integer, primary key, auto increment)
  - user_uuid (string/varchar, not null, unique, indexed)
  - user_name (string, not null, unique)
  - password_digest (string, not null)
  - created_at (datetime, not null)
  - updated_at (datetime, not null)

#### Scenario: User UUID generation
- **WHEN** 新しいUserレコードが作成される
- **THEN** user_uuidはUUIDv4形式で自動生成される
- **AND** user_uuidは文字列型カラムに保存される
- **AND** user_uuidはデータベース内で一意である

#### Scenario: Username uniqueness constraint
- **WHEN** 重複したユーザー名でUserを作成しようとする
- **THEN** データベースはユニーク制約違反エラーを返す
- **AND** レコードは作成されない

#### Scenario: Password digest storage
- **WHEN** Userが作成される
- **THEN** パスワードはbcryptでハッシュ化され、password_digestカラムに保存される
- **AND** 平文パスワードは保存されない

### Requirement: Space Model
システムは、掲示板情報を管理するSpaceモデルをSHALL定義する。Spaceテーブルには、ID、UUID、タイムスタンプが含まれる。UUIDは文字列型で保存される。

#### Scenario: Space table schema
- **WHEN** データベースマイグレーションを実行
- **THEN** 以下のカラムを持つspacesテーブルが作成される:
  - id (integer, primary key, auto increment)
  - space_uuid (string/varchar, not null, unique, indexed)
  - space_name (string, not null, unique)
  - created_at (datetime, not null)
  - updated_at (datetime, not null)

#### Scenario: Space UUID generation
- **WHEN** 新しいSpaceレコードが作成される
- **THEN** space_uuidはUUIDv4形式で自動生成される
- **AND** space_uuidは文字列型カラムに保存される
- **AND** space_uuidはデータベース内で一意である

#### Scenario: Space name uniqueness constraint
- **WHEN** 重複したSpace名でSpaceを作成しようとする
- **THEN** データベースはユニーク制約違反エラーを返す
- **AND** レコードは作成されない

### Requirement: Message Model
システムは、メッセージ情報を管理するMessageモデルをSHALL定義する。Messageテーブルには、UUID、送信者UUID、Space UUID、内容、タイムスタンプが含まれる。UUIDは文字列型で保存される。

#### Scenario: Message table schema
- **WHEN** データベースマイグレーションを実行
- **THEN** 以下のカラムを持つmessagesテーブルが作成される:
  - id (integer, primary key, auto increment)
  - message_uuid (string/varchar, not null, unique, indexed)
  - sender_uuid (string/varchar, not null, indexed)
  - space_uuid (string/varchar, not null, indexed)
  - content (text, not null)
  - created_at (datetime, not null)
  - updated_at (datetime, not null)

#### Scenario: Message UUID generation
- **WHEN** 新しいMessageレコードが作成される
- **THEN** message_uuidはUUIDv4形式で自動生成される
- **AND** message_uuidは文字列型カラムに保存される
- **AND** message_uuidはデータベース内で一意である

#### Scenario: Foreign key relationships
- **WHEN** Messageレコードが作成される
- **THEN** sender_uuidはusersテーブルのuser_uuidを参照する
- **AND** space_uuidはspacesテーブルのspace_uuidを参照する
- **AND** 参照先のレコードが存在しない場合、作成は失敗する

#### Scenario: Message content validation
- **WHEN** Messageレコードが作成される
- **THEN** contentカラムは空でない
- **AND** contentの長さは500文字以下である

### Requirement: Database Indexes
システムは、パフォーマンス向上のためにUUIDカラムにインデックスをSHALL作成する。UUIDは文字列型で管理される。

#### Scenario: UUID indexes
- **WHEN** データベースマイグレーションを実行
- **THEN** 以下のカラムにインデックスが作成される:
  - users.user_uuid (unique index)
  - spaces.space_uuid (unique index)
  - messages.message_uuid (unique index)
  - messages.sender_uuid (index)
  - messages.space_uuid (index)

#### Scenario: Composite index for messages
- **WHEN** データベースマイグレーションを実行
- **THEN** messages(space_uuid, created_at)に複合インデックスが作成される
- **AND** これにより、Space内のメッセージを時系列順に効率的に取得できる

### Requirement: Database Connection Pool
システムは、データベース接続プールをSHALL使用してパフォーマンスを最適化する。SQLiteの特性に適した設定を使用する。

#### Scenario: Connection pool configuration
- **WHEN** Railsアプリケーションが起動
- **THEN** データベース接続プールが設定される
- **AND** プールサイズは環境変数RAILS_MAX_THREADSまたはデフォルト値 (5) である
- **AND** SQLiteに適したタイムアウト設定が適用される

