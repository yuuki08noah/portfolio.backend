class HireRequest < ApplicationRecord
  validates :name, :email, :schedule_iso, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :status, inclusion: { in: %w[new sent failed] }

  before_validation :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= 'new'
  end
end
