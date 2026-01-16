class Message < ApplicationRecord
  # Associations
  belongs_to :user, foreign_key: :sender_uuid, primary_key: :user_uuid
  belongs_to :space, foreign_key: :space_uuid, primary_key: :space_uuid

  # Validations
  validates :message_uuid, presence: true, uniqueness: true
  validates :sender_uuid, presence: true
  validates :space_uuid, presence: true
  validates :content, presence: true, length: { maximum: 500 }

  # Callbacks
  before_validation :generate_uuid, on: :create

  # Default scope to order by creation time
  default_scope { order(created_at: :asc) }

  private

  def generate_uuid
    self.message_uuid ||= SecureRandom.uuid
  end
end
