class Award < ApplicationRecord
  belongs_to :user

  validates :title, :organization, :date, presence: true

  scope :recent, -> { order(date: :desc) }
end
