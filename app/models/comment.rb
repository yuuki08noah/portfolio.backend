class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  belongs_to :parent, class_name: "Comment", optional: true

  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy

  validates :content, presence: true
  validates :path, presence: true
  validates :depth, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :locale, presence: true, inclusion: { in: %w[en ko ja] }

  before_validation :set_path_and_depth, on: :create

  scope :root_comments, -> { where(parent_id: nil) }
  scope :ordered_by_path, -> { order(:path) }
  scope :by_locale, ->(locale) { where(locale: locale) }

  def ancestors
    return [] if path.blank?
    
    ancestor_ids = path.split("/").reject(&:blank?).map(&:to_i)
    ancestor_ids.empty? ? [] : Comment.where(id: ancestor_ids).order(:depth)
  end

  def descendants
    Comment.where("path LIKE ?", "#{path}/%").order(:path)
  end

  private

  def set_path_and_depth
    if parent_id.present?
      parent_comment = Comment.find(parent_id)
      self.depth = parent_comment.depth + 1
      self.path = "#{parent_comment.path}/#{parent_comment.id}"
    else
      self.depth = 0
      self.path = ""
    end
  end
end
