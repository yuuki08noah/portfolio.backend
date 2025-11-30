class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.string :author, null: false
      t.string :publisher
      t.string :status, null: false
      t.date :start_date
      t.date :end_date
      t.integer :rating
      t.text :review
      t.string :cover_image
      t.text :categories
      t.integer :pages

      t.timestamps
    end
  end
end
