class AddTranslationsToTravelPlans < ActiveRecord::Migration[8.1]
  def change
    add_column :travel_plans, :destination_city_ko, :string
    add_column :travel_plans, :destination_country_ko, :string
    add_column :travel_plans, :notes_ko, :text
  end
end
