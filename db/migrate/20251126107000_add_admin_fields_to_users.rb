class AddAdminFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :role, :string, default: 'user', null: false
    add_column :users, :admin_status, :string, default: 'active', null: false
    add_column :users, :admin_invite_token, :string
    add_column :users, :admin_invite_expires_at, :datetime
    add_column :users, :admin_invited_by, :integer
    add_column :users, :admin_approved_by, :text
    add_column :users, :admin_status_reason, :text
    add_column :users, :last_login_at, :datetime

    add_index :users, :role
    add_index :users, :admin_status
    add_index :users, :admin_invite_token, unique: true
  end
end
