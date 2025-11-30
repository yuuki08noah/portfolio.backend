class CreateReadingGoals < ActiveRecord::Migration[8.1]
  def change
    create_table :reading_goals do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :year, null: false
      t.integer :target_books, null: false
      t.integer :current_books, null: false, default: 0

      t.timestamps
    end
  end
end
