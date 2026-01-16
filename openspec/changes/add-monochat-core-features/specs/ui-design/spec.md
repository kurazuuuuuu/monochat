# UI Design Specification

## ADDED Requirements

### Requirement: Monochrome Design
システムは、全てのUI要素をモノクロ (白、黒、グレー) でSHALL表示する。カラーは使用してはならない。

#### Scenario: All UI elements are monochrome
- **WHEN** ユーザーがアプリケーションの任意の画面を開く
- **THEN** 全てのUI要素 (背景、テキスト、ボタン、枠線など) は白、黒、グレーのいずれかである
- **AND** カラー (赤、青、緑など) は使用されていない

#### Scenario: Background colors
- **WHEN** ユーザーがアプリケーションを表示
- **THEN** 背景色は白またはライトグレー (#f5f5f5など) である
- **AND** テキストは黒または濃いグレーである

#### Scenario: Button and input styles
- **WHEN** ユーザーがボタンや入力フィールドを操作
- **THEN** ボタンは白背景に黒枠線、またはグレー背景で表示される
- **AND** 入力フィールドは白背景にグレー枠線で表示される
- **AND** ホバー時はグレーに変化する

### Requirement: DotGothic16 Font
システムは、全てのテキストにGoogle FontsのDotGothic16フォントをSHALL使用する。

#### Scenario: Font applied to all text
- **WHEN** ユーザーがアプリケーションの任意の画面を開く
- **THEN** 全てのテキスト (ヘッダー、本文、ボタンなど) にDotGothic16フォントが適用される
- **AND** フォントはGoogle Fontsから読み込まれる

#### Scenario: Fallback font
- **WHEN** DotGothic16フォントの読み込みに失敗した場合
- **THEN** システムはフォールバックフォント (monospace系) を使用する
- **AND** ユーザーにはエラーメッセージが表示されない

### Requirement: Tabler Icons
システムは、全てのアイコンにTabler IconsをSHALL使用する。アイコンはモノクロでスタイリングされる。

#### Scenario: Icons styled as monochrome
- **WHEN** ユーザーがアイコンを含む画面を開く
- **THEN** 全てのアイコンは黒または濃いグレーで表示される
- **AND** アイコンはTabler Iconsから取得される

#### Scenario: Common icons used
- **WHEN** アプリケーションで以下のアクションが表示される
- **THEN** 対応するTabler Iconsが使用される:
  - 送信: IconSend
  - 新規作成: IconPlus
  - ログイン: IconLogin
  - ログアウト: IconLogout
  - ホーム: IconHome

### Requirement: Login Screen Layout
システムは、ログイン画面をシンプルでSHALL表示する。パスワード入力フィールドとログイン/登録ボタンのみを含む。

#### Scenario: Login screen elements
- **WHEN** ユーザーがログイン画面を開く
- **THEN** 画面中央にパスワード入力フィールドが表示される
- **AND** 入力フィールドの下に「Login」ボタンと「Register」ボタンが表示される
- **AND** 画面上部にアプリタイトル「MonoChat」が表示される

#### Scenario: Password input field styling
- **WHEN** ユーザーがパスワード入力フィールドを見る
- **THEN** 入力フィールドは白背景、グレー枠線で表示される
- **AND** プレースホルダーテキストは「Enter password」と表示される
- **AND** 入力内容はマスクされる (●●●●)

#### Scenario: Login and register buttons
- **WHEN** ユーザーがログイン画面を開く
- **THEN** 「Login」ボタンと「Register」ボタンが横並びで表示される
- **AND** ボタンは白背景、黒枠線で表示される
- **AND** ホバー時はグレー背景に変化する

### Requirement: Home Screen Layout
システムは、ホーム画面にヘッダー、ボディ、フッターをSHALL表示する。ボディにはSpace一覧と「New Space」ボタンが含まれる。

#### Scenario: Home screen header
- **WHEN** ユーザーがホーム画面を開く
- **THEN** 画面上部にヘッダーが表示される
- **AND** ヘッダー左側にアプリタイトル「MonoChat」が表示される
- **AND** ヘッダー右側にユーザー名が表示される

#### Scenario: Home screen body
- **WHEN** ユーザーがホーム画面を開く
- **THEN** 画面中央にSpace一覧が表示される
- **AND** 各Spaceは白背景、黒枠線のカードとして表示される
- **AND** 画面下部に「New Space」ボタンが表示される

#### Scenario: Home screen footer
- **WHEN** ユーザーがホーム画面を開く
- **THEN** 画面下部にフッターが表示される
- **AND** フッター右側に「Author」「GitHub Repo」「Ruby on Rails」のリンクが表示される

### Requirement: Space Screen Layout
システムは、Space画面にメッセージ一覧と入力ボックスをSHALL表示する。

#### Scenario: Space screen message display
- **WHEN** ユーザーがSpace画面を開く
- **THEN** メッセージは左寄せで時系列順に表示される
- **AND** 各メッセージは白背景、黒枠線のテキストボックスである
- **AND** メッセージ上部に送信者のユーザー名が表示される

#### Scenario: Space screen input box
- **WHEN** ユーザーがSpace画面を開く
- **THEN** 画面下部中央にメッセージ入力ボックスが表示される
- **AND** 入力ボックスは白背景、グレー枠線で表示される
- **AND** 入力ボックス右下に送信ボタンが表示される

#### Scenario: Send button state
- **WHEN** ユーザーがメッセージを送信中
- **THEN** 送信ボタンはグレーアウトされる
- **AND** ボタンのテキストが「Sending...」に変化する
- **AND** 送信完了後、ボタンは元の状態に戻る

### Requirement: Responsive Design
システムは、デスクトップとモバイルの両方でSHALL適切に表示される。

#### Scenario: Desktop layout
- **WHEN** ユーザーがデスクトップブラウザでアプリケーションを開く
- **THEN** コンテンツは画面中央に配置され、最大幅は1200pxである
- **AND** Space一覧は2列または3列で表示される

#### Scenario: Mobile layout
- **WHEN** ユーザーがモバイルブラウザでアプリケーションを開く
- **THEN** コンテンツは画面幅いっぱいに表示される
- **AND** Space一覧は1列で表示される
- **AND** ヘッダーのアプリタイトルとユーザー名は縦に並ぶ

### Requirement: Loading States
システムは、データ読み込み中にローディング表示をSHALLする。

#### Scenario: Loading indicator
- **WHEN** システムがデータを読み込み中
- **THEN** 画面中央にローディングスピナー (モノクロ) が表示される
- **AND** スピナーは回転アニメーションを持つ

#### Scenario: Skeleton loading for spaces
- **WHEN** ホーム画面でSpace一覧を読み込み中
- **THEN** Space一覧の位置にスケルトンローディング (グレーのプレースホルダー) が表示される
- **AND** データ読み込み完了後、スケルトンは実際のSpaceに置き換えられる

### Requirement: Error Display
システムは、エラーメッセージをユーザーにSHALL表示する。

#### Scenario: Error message display
- **WHEN** システムでエラーが発生
- **THEN** 画面上部にエラーメッセージが表示される
- **AND** エラーメッセージは白背景、黒枠線のボックスである
- **AND** エラーメッセージには閉じるボタン (X) が含まれる

#### Scenario: Form validation errors
- **WHEN** フォーム送信時にバリデーションエラーが発生
- **THEN** 該当するフォームフィールドの下にエラーメッセージが表示される
- **AND** エラーメッセージはグレーのテキストで表示される

### Requirement: Accessibility
システムは、基本的なアクセシビリティをSHALLサポートする。

#### Scenario: Keyboard navigation
- **WHEN** ユーザーがキーボードのTabキーを使用
- **THEN** フォーカス可能な要素 (ボタン、入力フィールド) が順番にフォーカスされる
- **AND** フォーカスされた要素には視覚的なインジケーター (黒い枠線) が表示される

#### Scenario: Alt text for icons
- **WHEN** アイコンが画面に表示される
- **THEN** 各アイコンには適切なalt属性またはaria-labelが設定される
- **AND** スクリーンリーダーがアイコンの意味を読み上げられる
