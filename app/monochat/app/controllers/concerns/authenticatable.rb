module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request
  end

  private

  def authenticate_request
    # トークンの取得: Authorizationヘッダー or Cookie
    token = extract_token_from_request

    decoded = JsonWebToken.decode(token)
    @current_user = User.find_by(user_uuid: decoded[:user_uuid]) if decoded
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "User not found: #{e.message}"
    handle_unauthorized
  end

  def current_user
    @current_user
  end

  def require_authentication!
    handle_unauthorized unless current_user
  end

  private

  # リクエストからトークンを抽出
  def extract_token_from_request
    # 1. Authorizationヘッダーから取得 (API用)
    header = request.headers["Authorization"]
    return header.split(" ").last if header

    # 2. Cookieから取得 (HTML用)
    cookies[:monochat_token]
  end

  # 認証エラー処理（JSON or リダイレクト）
  def handle_unauthorized
    if request.format.html?
      # HTML画面アクセス時は/loginへリダイレクト
      redirect_to login_path, alert: "ログインが必要です"
    else
      # API呼び出し時はJSONエラーを返す
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
