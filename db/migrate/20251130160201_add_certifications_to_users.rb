class AddCertificationsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :certifications, :text
  end
end
