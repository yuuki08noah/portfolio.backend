class CreateTranslationsTable < ActiveRecord::Migration[8.1]
  def change
    # 범용 번역 테이블 생성
    create_table :translations do |t|
      t.string :translatable_type, null: false  # 모델 이름 (User, Book, TravelDiary 등)
      t.integer :translatable_id, null: false   # 해당 레코드 ID
      t.string :locale, null: false             # 언어 코드 (en, ko)
      t.string :field_name, null: false         # 필드 이름 (title, bio, description 등)
      t.text :value                             # 번역된 값

      t.timestamps
    end

    # 복합 인덱스로 빠른 조회
    add_index :translations, [:translatable_type, :translatable_id, :locale, :field_name], 
              unique: true, name: 'index_translations_unique'
    add_index :translations, [:translatable_type, :translatable_id, :locale], 
              name: 'index_translations_by_record_locale'
  end
end
