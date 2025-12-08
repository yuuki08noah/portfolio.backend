class Milestone < ApplicationRecord
  include Translatable
  belongs_to :user

  serialize :details, coder: JSON

  enum :milestone_type, { work: 'work', education: 'education', scholarship: 'scholarship', activity: 'activity' }

  translatable_fields :title, :organization, :details

  validates :title, :milestone_type, :period, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
