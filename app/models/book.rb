class Book < ApplicationRecord
  include Translatable
  
  belongs_to :user

  translatable_fields :title, :author, :review

  serialize :categories, type: Array, coder: JSON

  enum :status, { completed: "completed", reading: "reading", to_read: "to-read" }

  before_validation :set_default_status, if: :new_record?

  scope :recent, -> { order(updated_at: :desc) }
  scope :completed, -> { where(status: "completed") }

  validates :title, :author, :status, presence: true
  validates :rating, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_nil: true

  private

  def set_default_status
    self.status ||= :to_read
  end
end
