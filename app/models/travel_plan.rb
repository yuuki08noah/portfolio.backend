class TravelPlan < ApplicationRecord
  include Translatable
  
  belongs_to :user

  translatable_fields :destination_city, :destination_country, :notes

  serialize :checklist, coder: JSON
  serialize :bucket_list, coder: JSON
  serialize :itinerary, coder: JSON

  enum :status, { planning: 'planning', booked: 'booked', completed: 'completed', cancelled: 'cancelled' }

  before_validation :set_default_status, if: -> { status.blank? }

  scope :recent, -> { order(updated_at: :desc) }

  validates :destination_country, :destination_city, presence: true

  private

  def set_default_status
    self.status = 'planning'
  end
end
