class AddAuthFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :email_verified, :boolean
    add_column :users, :email_verification_token, :string
    add_column :users, :password_reset_token, :string
    add_column :users, :password_reset_expires_at, :datetime
    add_column :users, :refresh_token, :string
  end
end
