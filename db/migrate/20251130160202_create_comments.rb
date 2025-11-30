class CreateComments < ActiveRecord::Migration[8.1]
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.references :parent, null: true, foreign_key: { to_table: :comments }
      t.text :content, null: false
      t.string :path, null: false
      t.integer :depth, null: false, default: 0

      t.timestamps
    end

    add_index :comments, :path
    add_index :comments, [:commentable_type, :commentable_id]
  end
end
