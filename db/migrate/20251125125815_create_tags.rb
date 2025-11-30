class CreateTags < ActiveRecord::Migration[8.1]
  def change
    create_table :tags do |t|
      t.string :name
      t.string :slug
      t.integer :post_count
      t.integer :usage_count

      t.timestamps
    end
  end
end
