class AuthController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_request, only: [ :register, :login ]

  # POST /auth/register
  def register
    user = User.new(password: params[:password])

    if user.save
      token = JsonWebToken.encode(user_uuid: user.user_uuid)
      render json: {
        user_uuid: user.user_uuid,
        user_name: user.user_name,
        token: token
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /auth/login
  def login
    user = User.find_by(user_uuid: params[:user_uuid])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_uuid: user.user_uuid)
      render json: {
        user_uuid: user.user_uuid,
        user_name: user.user_name,
        token: token
      }, status: :ok
    else
      render json: { error: "Invalid UUID or password" }, status: :unauthorized
    end
  end

  # GET /auth/me
  def me
    if current_user
      render json: {
        user_uuid: current_user.user_uuid,
        user_name: current_user.user_name
      }, status: :ok
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
