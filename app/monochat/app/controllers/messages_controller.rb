class MessagesController < ApplicationController
  include RateLimitable

  # 認証必須
  before_action :require_authentication!
  before_action :set_space, only: [:index, :create]

  # GET /spaces/:space_uuid/messages
  def index
    @messages = @space.messages.includes(:user).order(created_at: :asc)
    render json: @messages.map { |m| format_message(m) }
  end

  # POST /spaces/:space_uuid/messages
  def create
    @message = @space.messages.build(message_params)
    @message.sender_uuid = current_user.user_uuid

    if @message.save
      render json: format_message(@message), status: :created
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_space
    @space = Space.find_by(space_uuid: params[:space_uuid])

    unless @space
      render json: { error: "Space not found" }, status: :not_found
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def format_message(message)
    {
      message_uuid: message.message_uuid,
      sender_uuid: message.sender_uuid,
      sender_name: message.user.user_name,
      content: message.content,
      created_at: message.created_at.iso8601
    }
  end
end
