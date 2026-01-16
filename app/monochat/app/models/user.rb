class User < ApplicationRecord
  has_secure_password

  # Associations
  has_many :messages, foreign_key: :sender_uuid, primary_key: :user_uuid, dependent: :destroy

  # Validations
  validates :user_uuid, presence: true, uniqueness: true
  validates :user_name, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { password.present? }

  # Callbacks
  before_validation :generate_uuid, on: :create
  before_validation :generate_username, on: :create

  private

  def generate_uuid
    self.user_uuid ||= SecureRandom.uuid
  end

  def generate_username
    return if user_name.present?

    adjectives = %w[
      カッコイイ カワイイ ツヨイ ヨワイ ハヤイ スバラシイ ヨクシャベル ナンデモデキル
      カシコイ アタマガイイ
    ]

    nouns = %w[
      うま ひつじ しか いぬ とり ねこ ちーたー ぱんだ とら ねずみ ふくろう
    ]

    loop do
      candidate = "#{adjectives.sample}#{nouns.sample}"
      unless User.exists?(user_name: candidate)
        self.user_name = candidate
        break
      end
    end
  end
end
