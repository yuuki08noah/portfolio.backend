class Category < ApplicationRecord
  belongs_to :user
  has_many :blog_posts, dependent: :nullify

  before_validation :assign_slug

  validates :name, presence: true
  validates :slug, uniqueness: { scope: :user_id }, allow_nil: true

  private

  def assign_slug
    return if slug.present? || name.blank?

    self.slug = name.parameterize
  end
end
