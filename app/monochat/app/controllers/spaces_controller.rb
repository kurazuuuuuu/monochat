class SpacesController < ApplicationController
  # 認証必須（Authenticatable concernでチェック）
  before_action :require_authentication!

  # GET /spaces
  def index
    @spaces = Space.all.order(created_at: :desc)
    @notice = flash[:notice]
  end

  # POST /spaces
  def create
    @space = Space.new

    if @space.save
      redirect_to spaces_path, notice: "✓ Space '#{@space.space_name}' created successfully!"
    else
      @spaces = Space.all.order(created_at: :desc)
      @errors = @space.errors.full_messages
      render :index, status: :unprocessable_entity
    end
  end

  # GET /spaces/:space_uuid
  def show
    @space = Space.find_by(space_uuid: params[:space_uuid])

    unless @space
      redirect_to spaces_path, alert: "Space not found"
      return
    end

    # メッセージはJavaScript経由でロードされる
  end
end
