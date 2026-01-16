# Messaging Specification

## ADDED Requirements

### Requirement: Message Creation
システムは、認証されたユーザーがSpace内にメッセージをSHALL投稿できる。メッセージには5秒のレート制限が適用される。

#### Scenario: Successful message creation
- **WHEN** 認証されたユーザーがメッセージ内容とSpace UUIDを指定してメッセージを投稿
- **THEN** システムはメッセージUUIDを生成し、送信者UUID、Space UUID、内容とともにDBに保存
- **AND** システムは作成されたメッセージの情報をレスポンスとして返す
- **AND** レスポンスステータスコードは201 (Created)

#### Scenario: Message creation without authentication
- **WHEN** 認証されていないユーザーがメッセージを投稿しようとする
- **THEN** システムはエラーメッセージ "Authentication required" を返す
- **AND** レスポンスステータスコードは401 (Unauthorized)

#### Scenario: Message creation with empty content
- **WHEN** ユーザーが空のメッセージ内容を投稿しようとする
- **THEN** システムはエラーメッセージ "Message content cannot be empty" を返す
- **AND** レスポンスステータスコードは422 (Unprocessable Entity)

#### Scenario: Message creation with content exceeding max length
- **WHEN** ユーザーが500文字を超えるメッセージ内容を投稿しようとする
- **THEN** システムはエラーメッセージ "Message content must be 500 characters or less" を返す
- **AND** レスポンスステータスコードは422 (Unprocessable Entity)

#### Scenario: Message creation in non-existent space
- **WHEN** ユーザーが存在しないSpace UUIDを指定してメッセージを投稿しようとする
- **THEN** システムはエラーメッセージ "Space not found" を返す
- **AND** レスポンスステータスコードは404 (Not Found)

### Requirement: Message Rate Limiting
システムは、ユーザーが5秒以内に複数のメッセージをSHALL投稿できないようにレート制限を適用する。

#### Scenario: Rate limit enforcement
- **WHEN** ユーザーが最後のメッセージ投稿から5秒以内に新しいメッセージを投稿しようとする
- **THEN** システムはエラーメッセージ "Please wait 5 seconds before posting again" を返す
- **AND** レスポンスステータスコードは429 (Too Many Requests)
- **AND** レスポンスヘッダーにはRetry-After: 5が含まれる

#### Scenario: Rate limit passed
- **WHEN** ユーザーが最後のメッセージ投稿から5秒以上経過した後に新しいメッセージを投稿
- **THEN** システムはメッセージの投稿を許可する
- **AND** レスポンスステータスコードは201 (Created)

#### Scenario: Rate limit per user
- **WHEN** 複数のユーザーが同時にメッセージを投稿
- **THEN** 各ユーザーのレート制限は独立して管理される
- **AND** あるユーザーのレート制限が他のユーザーに影響を与えない

### Requirement: Message Retrieval
システムは、Space UUID を使用してそのSpace内の全てのメッセージをSHALL取得できる。メッセージは作成日時の古い順にソートされる。

#### Scenario: Retrieve messages for a space
- **WHEN** ユーザーが有効なSpace UUIDを指定してメッセージを取得
- **THEN** システムは指定されたSpace内の全てのメッセージを作成日時の昇順で返す
- **AND** 各メッセージには、UUID、送信者ユーザー名、内容、作成日時が含まれる
- **AND** レスポンスステータスコードは200 (OK)

#### Scenario: Retrieve messages for non-existent space
- **WHEN** ユーザーが存在しないSpace UUIDを指定してメッセージを取得しようとする
- **THEN** システムはエラーメッセージ "Space not found" を返す
- **AND** レスポンスステータスコードは404 (Not Found)

#### Scenario: No messages in space
- **WHEN** ユーザーがメッセージが存在しないSpaceのメッセージを取得
- **THEN** システムは空の配列を返す
- **AND** レスポンスステータスコードは200 (OK)

#### Scenario: Paginated message retrieval
- **WHEN** ユーザーがページネーションパラメータを指定してメッセージを取得
- **THEN** システムは指定されたページのメッセージを返す
- **AND** レスポンスには、現在のページ、総ページ数、総メッセージ数が含まれる

### Requirement: Message Display in Space View
システムは、Space画面でメッセージをSHALL表示する。メッセージは左寄せで、送信者のユーザー名とともに表示される。

#### Scenario: Display messages in space view
- **WHEN** ユーザーがSpace画面を開く
- **THEN** システムはそのSpace内の全てのメッセージを時系列順に表示する
- **AND** 各メッセージには送信者のユーザー名が上部に表示される
- **AND** メッセージは白い背景、黒い枠線のテキストボックスで表示される

#### Scenario: Message input box in space view
- **WHEN** ユーザーがSpace画面を開く
- **THEN** 画面下部中央にメッセージ入力ボックスが表示される
- **AND** 入力ボックスには右下に送信ボタンが含まれる
- **AND** 送信ボタンをクリックするとメッセージが投稿される

#### Scenario: Send button disabled during submission
- **WHEN** ユーザーが送信ボタンをクリックしてメッセージを投稿中
- **THEN** 送信ボタンはグレーアウトされ、クリックできない状態になる
- **AND** メッセージ投稿完了後、送信ボタンは再度有効になる

#### Scenario: Real-time message updates
- **WHEN** 他のユーザーがメッセージを投稿
- **THEN** システムは自動的に新しいメッセージをSpace画面に表示する
- **AND** ユーザーはページをリロードする必要がない

### Requirement: Message Content Sanitization
システムは、メッセージ内容をサニタイズしてXSS攻撃をSHALL防止する。

#### Scenario: Message content with HTML tags
- **WHEN** ユーザーがHTMLタグを含むメッセージを投稿
- **THEN** システムはHTMLタグをエスケープして安全な形式で保存
- **AND** 表示時にはHTMLタグがそのまま表示され、実行されない

#### Scenario: Message content with JavaScript
- **WHEN** ユーザーがJavaScriptコードを含むメッセージを投稿
- **THEN** システムはコードをエスケープして安全な形式で保存
- **AND** 表示時にはコードがそのまま表示され、実行されない
