class AddFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :profile, :text
    add_column :users, :name, :string
    add_column :users, :company, :string
  end
end
