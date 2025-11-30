class AddProfileContentToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :skills, :text
    add_column :users, :tagline, :string
    add_column :users, :values, :text
    add_column :users, :external_links, :text
  end
end
