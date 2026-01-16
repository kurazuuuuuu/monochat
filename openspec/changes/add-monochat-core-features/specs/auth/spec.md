# Auth Specification

## ADDED Requirements

### Requirement: User Registration
システムは、パスワードのみを使用してユーザー登録をSHALLサポートする。ユーザー登録時に、システムはUUIDとユーザー名を自動生成し、パスワードをbcryptでハッシュ化してデータベースに保存しなければならない。

#### Scenario: Successful registration
- **WHEN** ユーザーが有効なパスワード (8文字以上) を入力して登録
- **THEN** システムはユーザーUUID、ランダムなユーザー名を生成し、パスワードをハッシュ化してDBに保存
- **AND** システムはユーザーUUIDとJWTトークンをレスポンスとして返す
- **AND** レスポンスステータスコードは201 (Created)

#### Scenario: Registration with invalid password
- **WHEN** ユーザーが8文字未満のパスワードを入力して登録
- **THEN** システムはエラーメッセージ "Password must be at least 8 characters" を返す
- **AND** レスポンスステータスコードは422 (Unprocessable Entity)

#### Scenario: Username generation uniqueness
- **WHEN** ユーザー登録時にユーザー名が自動生成される
- **THEN** 生成されたユーザー名はデータベース内で一意でなければならない
- **AND** もし重複した場合は、再生成を試みる (最大10回)

### Requirement: User Login
システムは、UUIDとパスワードを使用してユーザーログインをSHALLサポートする。認証成功時には、JWTトークンを発行しなければならない。

#### Scenario: Successful login
- **WHEN** ユーザーが有効なUUIDとパスワードを入力してログイン
- **THEN** システムはパスワードを検証し、認証成功時にJWTトークンを返す
- **AND** レスポンスステータスコードは200 (OK)
- **AND** レスポンスにはJWTトークンとユーザー名が含まれる

#### Scenario: Login with invalid credentials
- **WHEN** ユーザーが無効なUUIDまたはパスワードを入力してログイン
- **THEN** システムはエラーメッセージ "Invalid credentials" を返す
- **AND** レスポンスステータスコードは401 (Unauthorized)

#### Scenario: Login without UUID
- **WHEN** UUIDが提供されずにログインを試みる
- **THEN** システムはエラーメッセージ "UUID is required" を返す
- **AND** レスポンスステータスコードは400 (Bad Request)

### Requirement: JWT Token Authentication
システムは、JWTトークンを使用して認証を行い、保護されたエンドポイントへのアクセスをSHALL制御する。

#### Scenario: Access protected endpoint with valid token
- **WHEN** ユーザーが有効なJWTトークンを含むリクエストを送信
- **THEN** システムはトークンを検証し、リクエストを許可する
- **AND** リクエストにはユーザーUUIDがコンテキストとして含まれる

#### Scenario: Access protected endpoint without token
- **WHEN** ユーザーがJWTトークンなしでリクエストを送信
- **THEN** システムはエラーメッセージ "Authentication required" を返す
- **AND** レスポンスステータスコードは401 (Unauthorized)

#### Scenario: Access protected endpoint with expired token
- **WHEN** ユーザーが期限切れのJWTトークンを含むリクエストを送信
- **THEN** システムはエラーメッセージ "Token expired" を返す
- **AND** レスポンスステータスコードは401 (Unauthorized)

#### Scenario: Access protected endpoint with invalid token
- **WHEN** ユーザーが無効なJWTトークンを含むリクエストを送信
- **THEN** システムはエラーメッセージ "Invalid token" を返す
- **AND** レスポンスステータスコードは401 (Unauthorized)

### Requirement: Password Security
システムは、パスワードをbcryptを使用してハッシュ化し、セキュアにSHALL保存する。平文パスワードはデータベースに保存してはならない。

#### Scenario: Password hashing on registration
- **WHEN** ユーザーが登録時にパスワードを入力
- **THEN** システムはパスワードをbcryptでハッシュ化してDBに保存
- **AND** 平文パスワードはデータベースに保存されない

#### Scenario: Password verification on login
- **WHEN** ユーザーがログイン時にパスワードを入力
- **THEN** システムはbcryptを使用してハッシュ化されたパスワードと照合
- **AND** 照合成功時のみ認証を許可する

### Requirement: Username Generation
システムは、ユーザー登録時にランダムなユーザー名をSHALL自動生成する。ユーザーはユーザー名を選択できない。

#### Scenario: Random username generation
- **WHEN** ユーザーが登録する
- **THEN** システムは形容詞と名詞を組み合わせたランダムなユーザー名を生成 (例: "RedPanda", "SilentWolf")
- **AND** 生成されたユーザー名はデータベース内で一意である

#### Scenario: Username format validation
- **WHEN** ユーザー名が生成される
- **THEN** ユーザー名は英数字のみを含み、スペースや特殊文字を含まない
- **AND** ユーザー名の長さは3文字以上20文字以下である

### Requirement: UUID Storage in Browser
システムは、ユーザー登録時に生成されたUUIDをフロントエンドでブラウザにSHALL保存する。UUIDは再ログイン時に使用される。

#### Scenario: UUID stored in browser after registration
- **WHEN** ユーザーが登録に成功
- **THEN** フロントエンドはレスポンスからUUIDを取得
- **AND** UUIDをブラウザのローカルストレージに保存

#### Scenario: UUID retrieved from browser on login
- **WHEN** ユーザーがログイン画面を開く
- **THEN** フロントエンドはローカルストレージからUUIDを取得
- **AND** ログインリクエストにUUIDを含める

#### Scenario: No UUID in browser
- **WHEN** ローカルストレージにUUIDが存在しない
- **THEN** フロントエンドはユーザーに新規登録を促すメッセージを表示
