class Space < ApplicationRecord
  # Associations
  has_many :messages, foreign_key: :space_uuid, primary_key: :space_uuid, dependent: :destroy

  # Validations
  validates :space_uuid, presence: true, uniqueness: true
  validates :space_name, presence: true

  # Callbacks
  before_validation :generate_uuid, on: :create
  before_validation :generate_space_name, on: :create

  private

  def generate_uuid
    self.space_uuid ||= SecureRandom.uuid
  end

  def generate_space_name
    return if space_name.present?

    adjectives = %w[
      General Random Public Open Free Casual Anonymous Silent
      Secret Hidden Dark Light Bright Quiet Loud Active Quick
      Slow Deep Wide Grand Noble Royal Classic Modern Ancient
      Future Cyber Quantum Digital Virtual Astral Cosmic Zen
    ]

    nouns = %w[
      Hall Room Space Place Forum Board Channel Zone Arena
      Hub Station Portal Gateway Lounge Cafe Bar Garden Park
      Plaza Square Corner Spot Haven Refuge Hideout Sanctuary
      Chamber Alcove Nook Den Cave Vault Court Theater Stage
    ]

    self.space_name = "#{adjectives.sample} #{nouns.sample}"
  end
end
