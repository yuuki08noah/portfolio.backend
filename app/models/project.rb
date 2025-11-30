# == Schema Information
#
# Table name: projects
#
#  id           :uuid             not null, primary key
#  title        :string           not null
#  slug         :string           not null, unique
#  description  :text             not null
#  itinerary    :text             array
#  souvenirs    :string           array
#  stack        :string           array, not null
#  demo_url     :string
#  repo_url     :string
#  start_date   :date
#  end_date     :date
#  is_ongoing   :boolean          default(false), not null
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Project < ApplicationRecord
  belongs_to :user, optional: true
  has_many :blog_posts, class_name: 'ProjectBlogPost', dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  
  # Serialize arrays (SQLite stores as text)
  serialize :stack, coder: JSON
  serialize :itinerary, coder: JSON
  serialize :souvenirs, coder: JSON
  
  # Validations
  validates :title, presence: true, length: { minimum: 1, maximum: 100 }
  validates :description, presence: true, length: { minimum: 1, maximum: 1000 }
  validates :slug, presence: true, uniqueness: true
  validates :stack, presence: true
  validate :stack_must_have_at_least_one_item
  validate :end_date_after_start_date
  validates :demo_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true }
  validates :repo_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true }
  
  # Callbacks
  before_validation :generate_slug, on: :create
  before_validation :clear_end_date_if_ongoing
  after_create :create_overview_doc
  
  # Scopes
  scope :active, -> { where(deleted_at: nil) }
  scope :recent, -> { order(start_date: :desc, created_at: :desc) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :ongoing, -> { where(is_ongoing: true) }
  scope :completed, -> { where(is_ongoing: false).where.not(end_date: nil) }
  
  private
  
  def generate_slug
    return if title.blank?
    base_slug = title.parameterize
    
    # Handle non-ASCII titles (Korean, Japanese, etc.) that result in empty slug
    if base_slug.blank?
      # Use transliteration or create a random slug
      base_slug = "project-#{SecureRandom.hex(4)}"
    end
    
    self.slug = base_slug
    
    counter = 1
    while Project.exists?(slug: self.slug)
      self.slug = "#{base_slug}-#{counter}"
      counter += 1
    end
  end
  
  def create_overview_doc
    blog_posts.create!(
      category: 'overview',
      title: title,
      slug: 'overview',
      content: "# #{title}\n\n#{description}",
      order: 0
    )
  rescue => e
    Rails.logger.error "Failed to create overview doc for project #{id}: #{e.message}"
  end
  
  def stack_must_have_at_least_one_item
    if stack.blank? || stack.empty?
      errors.add(:stack, "must have at least one technology")
    end
  end

  def clear_end_date_if_ongoing
    self.end_date = nil if is_ongoing?
  end

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank? || is_ongoing?
    if end_date < start_date
      errors.add(:end_date, "must be after start date")
    end
  end
end
