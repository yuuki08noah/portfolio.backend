class ReadingGoal < ApplicationRecord
  belongs_to :user

  validates :year, :target_books, presence: true
  validates :target_books, numericality: { greater_than: 0 }
  validates :current_books, numericality: { greater_than_or_equal_to: 0 }

  def progress
    return 0.0 if target_books.to_i.zero?

    (current_books.to_f / target_books).round(2)
  end
end
