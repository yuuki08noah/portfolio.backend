class AddLocaleToComments < ActiveRecord::Migration[8.1]
  def change
    add_column :comments, :locale, :string, null: false, default: 'en'
    add_index :comments, :locale
    add_index :comments, [:commentable_type, :commentable_id, :locale]
  end
end
