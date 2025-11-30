class CreateTravelDiaries < ActiveRecord::Migration[8.1]
  def change
    create_table :travel_diaries do |t|
      t.references :user, null: false, foreign_key: true
      t.string :destination_country, null: false
      t.string :destination_city, null: false
      t.string :destination_code
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.string :title
      t.text :description
      t.text :days
      t.text :photos
      t.integer :rating
      t.text :expenses
      t.text :companions
      t.text :tags
      t.boolean :is_public, null: false, default: false

      t.timestamps
    end
  end
end
