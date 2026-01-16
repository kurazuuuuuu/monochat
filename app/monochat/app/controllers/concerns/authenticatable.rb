module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request
  end

  private

  def authenticate_request
    header = request.headers["Authorization"]
    header = header.split(" ").last if header
    
    decoded = JsonWebToken.decode(header)
    @current_user = User.find_by(user_uuid: decoded[:user_uuid]) if decoded
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "User not found: #{e.message}"
    render json: { error: "Unauthorized" }, status: :unauthorized
  end

  def current_user
    @current_user
  end

  def require_authentication!
    render json: { error: "Unauthorized" }, status: :unauthorized unless current_user
  end
end
