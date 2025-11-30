class AddTranslationsToTravelDiaries < ActiveRecord::Migration[8.1]
  def change
    add_column :travel_diaries, :title_ko, :string
    add_column :travel_diaries, :description_ko, :text
  end
end
