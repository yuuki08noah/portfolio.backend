class Translation < ApplicationRecord
  belongs_to :translatable, polymorphic: true

  validates :locale, presence: true
  validates :field_name, presence: true
  validates :translatable_type, presence: true
  validates :translatable_id, presence: true
  validates :locale, uniqueness: { scope: [:translatable_type, :translatable_id, :field_name] }

  SUPPORTED_LOCALES = %w[en ko ja].freeze

  scope :for_locale, ->(locale) { where(locale: locale) }
  scope :for_field, ->(field) { where(field_name: field) }
end
