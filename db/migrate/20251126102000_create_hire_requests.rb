class CreateHireRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :hire_requests do |t|
      t.string :name, null: false
      t.string :company
      t.string :email, null: false
      t.text :message
      t.string :schedule_iso, null: false
      t.string :status, null: false, default: 'new'

      t.timestamps
    end
  end
end
