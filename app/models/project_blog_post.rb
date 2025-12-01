# == Schema Information
#
# Table name: project_blog_posts
#
#  id               :uuid             not null, primary key
#  project_id       :uuid             not null
#  category         :string           not null
#  title            :string           not null
#  slug             :string           not null
#  content          :text             not null
#  order            :integer          default(0)
#  velog_url        :string
#  velog_post_id    :string
#  velog_likes      :integer          default(0)
#  velog_comments   :integer          default(0)
#  velog_views      :integer          default(0)
#  velog_synced_at  :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class ProjectBlogPost < ApplicationRecord
  belongs_to :project
  
  # Enums
  enum :category, {
    overview: 'overview',
    troubleshooting: 'troubleshooting',
    technical: 'technical',
    devlog: 'devlog',
    reference: 'reference'
  }, validate: true
  
  # Validations
  validates :title, presence: true, length: { minimum: 1, maximum: 200 }
  validates :content, presence: true, length: { minimum: 1 }
  validates :slug, presence: true
  validates :category, presence: true
  validates :order, numericality: { greater_than_or_equal_to: 0 }
  validates :velog_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true }
  validates :slug, uniqueness: { scope: [:project_id, :category] }
  
  # Callbacks
  before_validation :generate_slug, on: :create
  
  # Scopes
  scope :by_category, ->(cat) { where(category: cat) }
  scope :ordered, -> { order(order: :asc, created_at: :asc) }
  scope :with_velog, -> { where.not(velog_url: nil) }
  
  private
  
  def generate_slug
    return if title.blank?
    return if slug.present?
    
    base_slug = title.parameterize
    self.slug = base_slug
    
    counter = 1
    while ProjectBlogPost.exists?(project_id: project_id, category: category, slug: self.slug)
      self.slug = "#{base_slug}-#{counter}"
      counter += 1
    end
  end
end
