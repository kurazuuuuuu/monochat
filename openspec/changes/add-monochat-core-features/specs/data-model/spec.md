# Data Model Specification

## ADDED Requirements

### Requirement: User Model
システムは、ユーザー情報を管理するUserモデルをSHALL定義する。Userテーブルには、ID、UUID、ユーザー名、パスワードハッシュ、タイムスタンプが含まれる。

#### Scenario: User table schema
- **WHEN** データベースマイグレーションを実行
- **THEN** 以下のカラムを持つusersテーブルが作成される:
  - id (integer, primary key, auto increment)
  - user_uuid (uuid, not null, unique, indexed)
  - user_name (string, not null, unique)
  - password_digest (string, not null)
  - created_at (datetime, not null)
  - updated_at (datetime, not null)

#### Scenario: User UUID generation
- **WHEN** 新しいUserレコードが作成される
- **THEN** user_uuidはUUIDv4形式で自動生成される
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
システムは、掲示板情報を管理するSpaceモデルをSHALL定義する。Spaceテーブルには、ID、UUID、タイムスタンプが含まれる。

#### Scenario: Space table schema
- **WHEN** データベースマイグレーションを実行
- **THEN** 以下のカラムを持つspacesテーブルが作成される:
  - id (integer, primary key, auto increment)
  - space_uuid (uuid, not null, unique, indexed)
  - space_name (string, not null, unique)
  - created_at (datetime, not null)
  - updated_at (datetime, not null)

#### Scenario: Space UUID generation
- **WHEN** 新しいSpaceレコードが作成される
- **THEN** space_uuidはUUIDv4形式で自動生成される
- **AND** space_uuidはデータベース内で一意である

#### Scenario: Space name uniqueness constraint
- **WHEN** 重複したSpace名でSpaceを作成しようとする
- **THEN** データベースはユニーク制約違反エラーを返す
- **AND** レコードは作成されない

### Requirement: Message Model
システムは、メッセージ情報を管理するMessageモデルをSHALL定義する。Messageテーブルには、UUID、送信者UUID、Space UUID、内容、タイムスタンプが含まれる。

#### Scenario: Message table schema
- **WHEN** データベースマイグレーションを実行
- **THEN** 以下のカラムを持つmessagesテーブルが作成される:
  - id (integer, primary key, auto increment)
  - message_uuid (uuid, not null, unique, indexed)
  - sender_uuid (uuid, not null, indexed)
  - space_uuid (uuid, not null, indexed)
  - content (text, not null)
  - created_at (datetime, not null)
  - updated_at (datetime, not null)

#### Scenario: Message UUID generation
- **WHEN** 新しいMessageレコードが作成される
- **THEN** message_uuidはUUIDv4形式で自動生成される
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
システムは、パフォーマンス向上のためにUUIDカラムにインデックスをSHALL作成する。

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

### Requirement: Model Associations
システムは、Rails Active Recordの関連付けをSHALL使用してモデル間の関係を定義する。

#### Scenario: User has many messages
- **WHEN** UserモデルとMessageモデルが定義される
- **THEN** UserモデルはMessagesとのhas_many関連を持つ
- **AND** user.messagesでユーザーの全てのメッセージを取得できる

#### Scenario: Space has many messages
- **WHEN** SpaceモデルとMessageモデルが定義される
- **THEN** SpaceモデルはMessagesとのhas_many関連を持つ
- **AND** space.messagesでSpace内の全てのメッセージを取得できる

#### Scenario: Message belongs to user and space
- **WHEN** MessageモデルがUserとSpaceと関連付けられる
- **THEN** MessageモデルはUserとのbelongs_to関連を持つ
- **AND** MessageモデルはSpaceとのbelongs_to関連を持つ
- **AND** message.userで送信者を取得できる
- **AND** message.spaceでメッセージが属するSpaceを取得できる

### Requirement: Model Validations
システムは、データ整合性を保つためにモデルレベルでバリデーションをSHALL定義する。

#### Scenario: User validations
- **WHEN** Userモデルが定義される
- **THEN** 以下のバリデーションが適用される:
  - user_uuidの存在と一意性
  - user_nameの存在と一意性
  - passwordの最小長 (8文字)

#### Scenario: Space validations
- **WHEN** Spaceモデルが定義される
- **THEN** 以下のバリデーションが適用される:
  - space_uuidの存在と一意性
  - space_nameの存在と一意性

#### Scenario: Message validations
- **WHEN** Messageモデルが定義される
- **THEN** 以下のバリデーションが適用される:
  - message_uuidの存在と一意性
  - sender_uuidの存在
  - space_uuidの存在
  - contentの存在と最大長 (500文字)

### Requirement: Database Connection Pool
システムは、データベース接続プールをSHALL使用してパフォーマンスを最適化する。

#### Scenario: Connection pool configuration
- **WHEN** Railsアプリケーションが起動
- **THEN** データベース接続プールが設定される
- **AND** プールサイズは環境変数DB_POOL_SIZEまたはデフォルト値 (5) である
- **AND** 接続タイムアウトは5秒である

### Requirement: Database Transactions
システムは、複数のレコード操作を伴う処理でトランザクションをSHALL使用する。

#### Scenario: User registration transaction
- **WHEN** ユーザーが登録する
- **THEN** UUID生成、ユーザー名生成、パスワードハッシュ化、DB保存が単一のトランザクション内で実行される
- **AND** いずれかの処理が失敗した場合、全ての変更がロールバックされる

#### Scenario: Message creation transaction
- **WHEN** メッセージが投稿される
- **THEN** レート制限チェック、メッセージ作成、DB保存が単一のトランザクション内で実行される
- **AND** いずれかの処理が失敗した場合、全ての変更がロールバックされる

### Requirement: Database Migration Rollback
システムは、マイグレーションのロールバックをSHALLサポートする。

#### Scenario: Migration rollback
- **WHEN** マイグレーションをロールバックする
- **THEN** 最後に実行されたマイグレーションが取り消される
- **AND** テーブルやカラムが削除される
- **AND** データベースは以前の状態に戻る

#### Scenario: Rollback multiple migrations
- **WHEN** 複数のマイグレーションをロールバックする
- **THEN** 指定された数のマイグレーションが逆順で取り消される
- **AND** データベースは指定されたバージョンに戻る
