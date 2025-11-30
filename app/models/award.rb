class Award < ApplicationRecord
  include Translatable

  belongs_to :user

  translatable_fields :title, :organization, :description

  scope :recent, -> { order(date: :desc) }
end
