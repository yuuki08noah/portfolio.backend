class Milestone < ApplicationRecord
  belongs_to :user

  serialize :details, coder: JSON

  enum :milestone_type, { work: 'work', education: 'education' }

  validates :title, :milestone_type, :period, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
