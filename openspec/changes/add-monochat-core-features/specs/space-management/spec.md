# Space Management Specification

## ADDED Requirements

### Requirement: Space Creation
システムは、認証されたユーザーが新しいSpace (掲示板) をSHALL作成できる。Space名はシステムによって自動生成され、ユーザーは選択できない。

#### Scenario: Successful space creation
- **WHEN** 認証されたユーザーが新しいSpaceを作成
- **THEN** システムはSpace UUID、ランダムなSpace名を生成し、DBに保存
- **AND** システムは作成されたSpaceの情報をレスポンスとして返す
- **AND** レスポンスステータスコードは201 (Created)

#### Scenario: Space creation without authentication
- **WHEN** 認証されていないユーザーがSpaceを作成しようとする
- **THEN** システムはエラーメッセージ "Authentication required" を返す
- **AND** レスポンスステータスコードは401 (Unauthorized)

#### Scenario: Space name generation uniqueness
- **WHEN** Space作成時にSpace名が自動生成される
- **THEN** 生成されたSpace名はデータベース内で一意でなければならない
- **AND** もし重複した場合は、再生成を試みる (最大10回)

### Requirement: Space Listing
システムは、全てのSpaceの一覧をSHALL取得できる。一覧は作成日時の新しい順にソートされる。

#### Scenario: Retrieve all spaces
- **WHEN** ユーザーがSpace一覧を取得
- **THEN** システムは全てのSpaceを作成日時の降順で返す
- **AND** 各Spaceには、UUID、名前、作成日時が含まれる
- **AND** レスポンスステータスコードは200 (OK)

#### Scenario: No spaces exist
- **WHEN** データベースにSpaceが存在しない場合
- **THEN** システムは空の配列を返す
- **AND** レスポンスステータスコードは200 (OK)

#### Scenario: Paginated space listing
- **WHEN** ユーザーがページネーションパラメータを指定してSpace一覧を取得
- **THEN** システムは指定されたページのSpaceを返す
- **AND** レスポンスには、現在のページ、総ページ数、総Space数が含まれる

### Requirement: Space Retrieval
システムは、Space UUIDを使用して特定のSpaceの詳細情報をSHALL取得できる。

#### Scenario: Retrieve space by UUID
- **WHEN** ユーザーが有効なSpace UUIDを指定してSpaceを取得
- **THEN** システムは指定されたSpaceの詳細情報を返す
- **AND** レスポンスには、UUID、名前、作成日時が含まれる
- **AND** レスポンスステータスコードは200 (OK)

#### Scenario: Retrieve non-existent space
- **WHEN** ユーザーが存在しないSpace UUIDを指定
- **THEN** システムはエラーメッセージ "Space not found" を返す
- **AND** レスポンスステータスコードは404 (Not Found)

### Requirement: Space Name Generation
システムは、Space作成時にランダムなSpace名をSHALL自動生成する。ユーザーはSpace名を選択できない。

#### Scenario: Random space name generation
- **WHEN** Spaceが作成される
- **THEN** システムは形容詞と名詞を組み合わせたランダムなSpace名を生成 (例: "CozyLounge", "BrightHall")
- **AND** 生成されたSpace名はデータベース内で一意である

#### Scenario: Space name format validation
- **WHEN** Space名が生成される
- **THEN** Space名は英数字のみを含み、スペースや特殊文字を含まない
- **AND** Space名の長さは5文字以上30文字以下である

### Requirement: Home Screen Display
システムは、ホーム画面でSpace一覧をSHALL表示する。ユーザーは各Spaceをクリックして詳細画面に遷移できる。

#### Scenario: Display space list on home screen
- **WHEN** ユーザーがホーム画面を開く
- **THEN** システムは全てのSpaceを一覧表示する
- **AND** 各Spaceには名前と作成日時が表示される
- **AND** 各Spaceはクリック可能で、クリックするとSpace詳細画面に遷移する

#### Scenario: New Space button on home screen
- **WHEN** ユーザーがホーム画面を開く
- **THEN** 画面に「New Space」ボタンが表示される
- **AND** ボタンをクリックするとSpace作成のポップアップが表示される

#### Scenario: Space creation popup
- **WHEN** ユーザーが「New Space」ボタンをクリック
- **THEN** Space作成確認のポップアップが表示される
- **AND** ポップアップには「Create」ボタンと「Cancel」ボタンが含まれる
- **AND** 「Create」ボタンをクリックすると新しいSpaceが作成される

