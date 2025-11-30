class User < ApplicationRecord
  include Translatable
  
  ROLES = %w[user admin super_admin].freeze
  ADMIN_STATUSES = %w[pending active rejected disabled].freeze

  translatable_fields :name, :bio, :tagline, :job_position, :location_city, :location_country

  has_secure_password

  has_many :projects, dependent: :destroy
  has_many :awards, dependent: :destroy
  has_many :blog_posts, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :milestones, dependent: :destroy
  has_many :books, dependent: :destroy
  has_many :reading_goals, dependent: :destroy
  has_many :travel_diaries, dependent: :destroy
  has_many :travel_plans, dependent: :destroy

  before_validation :normalize_email
  before_validation :ensure_admin_approved_by

  serialize :admin_approved_by, type: Array, coder: JSON
  serialize :skills, type: Array, coder: JSON
  serialize :values, type: Array, coder: JSON
  serialize :external_links, type: Array, coder: JSON
  serialize :certifications, type: Array, coder: JSON

  accepts_nested_attributes_for :awards, allow_destroy: true

  validates :role, presence: true, inclusion: { in: ROLES }
  validates :admin_status, inclusion: { in: ADMIN_STATUSES }, allow_nil: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }
  validates :name, presence: true
  validates :locale, inclusion: { in: %w[ko en], allow_nil: true }
  validates :theme_country, length: { maximum: 8 }, allow_nil: true
  validates :theme_city, length: { maximum: 32 }, allow_nil: true

  def generate_password_reset!
    update(
      password_reset_token: SecureRandom.hex(20),
      password_reset_expires_at: 2.hours.from_now
    )
  end

  def clear_password_reset!
    update(password_reset_token: nil, password_reset_expires_at: nil)
  end

  def generate_email_verification_token!
    update(email_verification_token: SecureRandom.hex(16), email_verified: false)
  end

  def admin?
    role == "admin" || role == "super_admin"
  end

  def super_admin?
    role == "super_admin"
  end

  def admin_invite_active?
    admin_invite_token.present? && admin_invite_expires_at.present? && admin_invite_expires_at.future?
  end

  private

  def normalize_email
    self.email = email.to_s.downcase.strip
  end

  def ensure_admin_approved_by
    self.admin_approved_by = [] if admin_approved_by.nil?
  end
end
