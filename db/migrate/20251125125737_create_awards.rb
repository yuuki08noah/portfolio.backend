class CreateAwards < ActiveRecord::Migration[8.1]
  def change
    create_table :awards do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :organization
      t.date :date
      t.text :description
      t.string :badge_image

      t.timestamps
    end
  end
end
