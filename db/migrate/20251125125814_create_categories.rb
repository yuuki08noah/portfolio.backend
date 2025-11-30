class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :slug
      t.text :description
      t.string :color
      t.string :icon
      t.integer :parent_id
      t.integer :post_count

      t.timestamps
    end
  end
end
