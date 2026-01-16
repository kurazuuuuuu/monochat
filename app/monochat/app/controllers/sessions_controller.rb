class SessionsController < ApplicationController
  skip_before_action :authenticate_request, only: [ :new, :create ]

  # GET /
  def new
    # CookieからUUIDを取得して表示
    @user_uuid = cookies[:monochat_uuid]
    @notice = flash[:notice]
  end

  # POST /auth (統合: 登録/ログイン)
  def create
    user_uuid = cookies[:monochat_uuid]
    
    # UUIDがある場合：ログイン
    if user_uuid
      user = User.find_by(user_uuid: user_uuid)

      if user&.authenticate(params[:password])
        token = JsonWebToken.encode(user_uuid: user.user_uuid)
        cookies[:monochat_token] = { value: token, httponly: true }
        
        # TODO: Home画面にリダイレクト（現在は未実装なのでログイン画面に戻す）
        redirect_to root_path, notice: "✓ Welcome back, #{user.user_name}!"
      else
        @error = "Invalid password"
        @user_uuid = user_uuid
        render :new, status: :unprocessable_entity
      end
    # UUIDがない場合：新規登録
    else
      user = User.new(password: params[:password])

      if user.save
        token = JsonWebToken.encode(user_uuid: user.user_uuid)
        
        # UUIDとトークンをCookieに保存
        cookies[:monochat_uuid] = { value: user.user_uuid, expires: 1.year.from_now }
        cookies[:monochat_token] = { value: token, httponly: true }
        
        # 登録成功
        redirect_to root_path, notice: "✓ Welcome, #{user.user_name}! Your account has been created."
      else
        @errors = user.errors.full_messages
        @user_uuid = nil
        render :new, status: :unprocessable_entity
      end
    end
  end

  # DELETE /logout
  def destroy
    # CookieからUUIDとトークンを削除
    cookies.delete(:monochat_uuid)
    cookies.delete(:monochat_token)
    redirect_to root_path, notice: "✓ Logged out successfully. Enter a password to create a new account."
  end
end
