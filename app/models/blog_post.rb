class BlogPost < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

  has_many :comments, as: :commentable, dependent: :destroy

  serialize :tags, coder: JSON

  enum :status, { draft: 0, published: 1, archived: 2 }

  scope :recent, -> { order(Arel.sql('COALESCE(published_at, created_at) DESC')) }
  scope :published_public, -> { where(status: :published, is_public: true) }

  validates :title, :slug, presence: true
  validates :slug, uniqueness: { scope: :user_id }

  after_initialize :set_defaults, if: :new_record?

  before_validation :assign_slug

  private

  def set_defaults
    self.status ||= :draft
    self.is_public = true if is_public.nil?
  end

  def assign_slug
    return if slug.present? || title.blank?

    self.slug = title.parameterize
  end
end
