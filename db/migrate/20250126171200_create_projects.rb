class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects, id: :uuid do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :description, null: false
      t.text :itinerary
      t.text :souvenirs
      t.text :stack, null: false
      t.string :demo_url
      t.string :repo_url
      t.date :date
      t.datetime :deleted_at
      t.timestamps
    end
    
    add_index :projects, :slug, unique: true
    add_index :projects, :deleted_at
  end
end
