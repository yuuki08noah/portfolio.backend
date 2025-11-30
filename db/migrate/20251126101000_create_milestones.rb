class CreateMilestones < ActiveRecord::Migration[8.1]
  def change
    create_table :milestones do |t|
      t.references :user, null: false, foreign_key: true
      t.string :milestone_type, null: false
      t.string :title, null: false
      t.string :organization
      t.string :period, null: false
      t.text :details
      t.string :location

      t.timestamps
    end
  end
end
