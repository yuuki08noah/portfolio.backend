class RemoveOldTranslationColumns < ActiveRecord::Migration[8.1]
  def change
    # Users 테이블에서 _ko 컬럼 제거
    remove_column :users, :name_ko, :string if column_exists?(:users, :name_ko)
    remove_column :users, :bio_ko, :text if column_exists?(:users, :bio_ko)
    remove_column :users, :tagline_ko, :string if column_exists?(:users, :tagline_ko)
    remove_column :users, :job_position_ko, :string if column_exists?(:users, :job_position_ko)
    remove_column :users, :location_city_ko, :string if column_exists?(:users, :location_city_ko)
    remove_column :users, :location_country_ko, :string if column_exists?(:users, :location_country_ko)
    remove_column :users, :values_ko, :json if column_exists?(:users, :values_ko)

    # Books 테이블에서 _ko 컬럼 제거
    remove_column :books, :title_ko, :string if column_exists?(:books, :title_ko)
    remove_column :books, :author_ko, :string if column_exists?(:books, :author_ko)
    remove_column :books, :review_ko, :text if column_exists?(:books, :review_ko)

    # TravelDiaries 테이블에서 _ko 컬럼 제거
    remove_column :travel_diaries, :title_ko, :string if column_exists?(:travel_diaries, :title_ko)
    remove_column :travel_diaries, :description_ko, :text if column_exists?(:travel_diaries, :description_ko)

    # TravelPlans 테이블에서 _ko 컬럼 제거
    remove_column :travel_plans, :destination_city_ko, :string if column_exists?(:travel_plans, :destination_city_ko)
    remove_column :travel_plans, :destination_country_ko, :string if column_exists?(:travel_plans, :destination_country_ko)
    remove_column :travel_plans, :notes_ko, :text if column_exists?(:travel_plans, :notes_ko)

    # SiteSettings 테이블에서 _ko 컬럼 제거
    remove_column :site_settings, :value_ko, :text if column_exists?(:site_settings, :value_ko)
  end
end
