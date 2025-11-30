class AddMoreTranslationsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :name_ko, :string
    add_column :users, :job_position_ko, :string
    add_column :users, :location_city_ko, :string
    add_column :users, :location_country_ko, :string
    add_column :users, :values_ko, :jsonb, default: []
  end
end
