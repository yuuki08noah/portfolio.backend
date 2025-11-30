class MigrateTranslationsToNewTable < ActiveRecord::Migration[8.1]
  def up
    # Users 테이블에서 번역 데이터 이전
    execute <<-SQL
      INSERT INTO translations (translatable_type, translatable_id, locale, field_name, value, created_at, updated_at)
      SELECT 'User', id, 'ko', 'name', name_ko, created_at, updated_at FROM users WHERE name_ko IS NOT NULL AND name_ko != '';
    SQL
    execute <<-SQL
      INSERT INTO translations (translatable_type, translatable_id, locale, field_name, value, created_at, updated_at)
      SELECT 'User', id, 'ko', 'bio', bio_ko, created_at, updated_at FROM users WHERE bio_ko IS NOT NULL AND bio_ko != '';
    SQL
    execute <<-SQL
      INSERT INTO translations (translatable_type, translatable_id, locale, field_name, value, created_at, updated_at)
      SELECT 'User', id, 'ko', 'tagline', tagline_ko, created_at, updated_at FROM users WHERE tagline_ko IS NOT NULL AND tagline_ko != '';
    SQL
    execute <<-SQL
      INSERT INTO translations (translatable_type, translatable_id, locale, field_name, value, created_at, updated_at)
      SELECT 'User', id, 'ko', 'job_position', job_position_ko, created_at, updated_at FROM users WHERE job_position_ko IS NOT NULL AND job_position_ko != '';
    SQL
    execute <<-SQL
      INSERT INTO translations (translatable_type, translatable_id, locale, field_name, value, created_at, updated_at)
      SELECT 'User', id, 'ko', 'location_city', location_city_ko, created_at, updated_at FROM users WHERE location_city_ko IS NOT NULL AND location_city_ko != '';
    SQL
    execute <<-SQL
      INSERT INTO translations (translatable_type, translatable_id, locale, field_name, value, created_at, updated_at)
      SELECT 'User', id, 'ko', 'location_country', location_country_ko, created_at, updated_at FROM users WHERE location_country_ko IS NOT NULL AND location_country_ko != '';
    SQL

    # Books 테이블에서 번역 데이터 이전
    execute <<-SQL
      INSERT INTO translations (translatable_type, translatable_id, locale, field_name, value, created_at, updated_at)
      SELECT 'Book', id, 'ko', 'title', title_ko, created_at, updated_at FROM books WHERE title_ko IS NOT NULL AND title_ko != '';
    SQL
    execute <<-SQL
      INSERT INTO translations (translatable_type, translatable_id, locale, field_name, value, created_at, updated_at)
      SELECT 'Book', id, 'ko', 'author', author_ko, created_at, updated_at FROM books WHERE author_ko IS NOT NULL AND author_ko != '';
    SQL
    execute <<-SQL
      INSERT INTO translations (translatable_type, translatable_id, locale, field_name, value, created_at, updated_at)
      SELECT 'Book', id, 'ko', 'review', review_ko, created_at, updated_at FROM books WHERE review_ko IS NOT NULL AND review_ko != '';
    SQL

    # TravelDiaries 테이블에서 번역 데이터 이전
    execute <<-SQL
      INSERT INTO translations (translatable_type, translatable_id, locale, field_name, value, created_at, updated_at)
      SELECT 'TravelDiary', id, 'ko', 'title', title_ko, created_at, updated_at FROM travel_diaries WHERE title_ko IS NOT NULL AND title_ko != '';
    SQL
    execute <<-SQL
      INSERT INTO translations (translatable_type, translatable_id, locale, field_name, value, created_at, updated_at)
      SELECT 'TravelDiary', id, 'ko', 'description', description_ko, created_at, updated_at FROM travel_diaries WHERE description_ko IS NOT NULL AND description_ko != '';
    SQL

    # TravelPlans 테이블에서 번역 데이터 이전
    execute <<-SQL
      INSERT INTO translations (translatable_type, translatable_id, locale, field_name, value, created_at, updated_at)
      SELECT 'TravelPlan', id, 'ko', 'destination_city', destination_city_ko, created_at, updated_at FROM travel_plans WHERE destination_city_ko IS NOT NULL AND destination_city_ko != '';
    SQL
    execute <<-SQL
      INSERT INTO translations (translatable_type, translatable_id, locale, field_name, value, created_at, updated_at)
      SELECT 'TravelPlan', id, 'ko', 'destination_country', destination_country_ko, created_at, updated_at FROM travel_plans WHERE destination_country_ko IS NOT NULL AND destination_country_ko != '';
    SQL
    execute <<-SQL
      INSERT INTO translations (translatable_type, translatable_id, locale, field_name, value, created_at, updated_at)
      SELECT 'TravelPlan', id, 'ko', 'notes', notes_ko, created_at, updated_at FROM travel_plans WHERE notes_ko IS NOT NULL AND notes_ko != '';
    SQL

    # SiteSettings 테이블에서 번역 데이터 이전
    execute <<-SQL
      INSERT INTO translations (translatable_type, translatable_id, locale, field_name, value, created_at, updated_at)
      SELECT 'SiteSetting', id, 'ko', 'value', value_ko, created_at, updated_at FROM site_settings WHERE value_ko IS NOT NULL AND value_ko != '';
    SQL
  end

  def down
    # 번역 데이터 삭제
    execute "DELETE FROM translations"
  end
end
