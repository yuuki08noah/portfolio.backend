class AddProfileFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :avatar_url, :string
    add_column :users, :phone, :string
    add_column :users, :github_url, :string
    add_column :users, :linkedin_url, :string
    add_column :users, :twitter_url, :string
    add_column :users, :website_url, :string
    add_column :users, :bio, :text
    add_column :users, :location_country, :string
    add_column :users, :location_city, :string
    add_column :users, :timezone, :string
    add_column :users, :locale, :string
    add_column :users, :currency, :string
    add_column :users, :theme_country, :string
    add_column :users, :theme_city, :string
    add_column :users, :dark_mode, :boolean, default: false, null: false
    add_column :users, :email_notifications, :boolean, default: true, null: false
  end
end
