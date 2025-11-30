class BlogPost < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

  has_many :comments, as: :commentable, dependent: :destroy

  serialize :tags, coder: JSON

  enum :status, { draft: 0, published: 1, archived: 2 }

  scope :recent, -> { order(published_at: :desc) }
  scope :published_public, -> { where(status: :published, is_public: true) }

  validates :title, :slug, presence: true
  validates :slug, uniqueness: { scope: :user_id }

  after_initialize :set_default_status, if: :new_record?

  before_validation :assign_slug

  private

  def set_default_status
    self.status ||= :draft
  end

  def assign_slug
    return if slug.present? || title.blank?

    self.slug = title.parameterize
  end
end
