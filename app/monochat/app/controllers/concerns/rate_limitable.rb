module RateLimitable
  extend ActiveSupport::Concern

  included do
    before_action :check_rate_limit, only: [:create]
  end

  private

  # 5秒間のレート制限チェック
  def check_rate_limit
    return unless current_user

    cache_key = "rate_limit:#{current_user.user_uuid}"
    last_message_time = Rails.cache.read(cache_key)

    if last_message_time && Time.current - last_message_time < 5.seconds
      remaining = 5 - (Time.current - last_message_time).to_i
      render json: {
        error: "Please wait #{remaining} seconds before posting again",
        retry_after: remaining
      }, status: :too_many_requests
      return
    end

    # 成功時にタイムスタンプを更新
    Rails.cache.write(cache_key, Time.current, expires_in: 5.seconds)
  end
end
