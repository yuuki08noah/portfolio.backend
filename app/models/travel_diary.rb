class TravelDiary < ApplicationRecord
  include Translatable
  
  belongs_to :user

  translatable_fields :title, :description

  serialize :days, coder: JSON
  serialize :photos, coder: JSON
  serialize :expenses, coder: JSON
  serialize :companions, coder: JSON
  serialize :tags, coder: JSON

  before_validation :set_defaults, if: -> { is_public.nil? }

  scope :recent, -> { order(start_date: :desc) }

  validates :destination_country, :destination_city, :start_date, :end_date, presence: true
  validates :is_public, inclusion: { in: [true, false] }

  private

  def set_defaults
    self.is_public = false
  end
end
