class CreateTravelPlans < ActiveRecord::Migration[8.1]
  def change
    create_table :travel_plans do |t|
      t.references :user, null: false, foreign_key: true
      t.string :destination_country, null: false
      t.string :destination_city, null: false
      t.string :destination_code
      t.date :target_date
      t.integer :duration
      t.decimal :budget_amount, precision: 12, scale: 2
      t.string :budget_currency
      t.string :status, null: false, default: 'planning'
      t.text :checklist
      t.text :bucket_list
      t.text :itinerary
      t.integer :time_slot_duration
      t.text :notes

      t.timestamps
    end
  end
end
