class AddTranslationsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :tagline_ko, :string
    add_column :users, :bio_ko, :text
  end
end
