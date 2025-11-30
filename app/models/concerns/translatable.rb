module Translatable
  extend ActiveSupport::Concern

  included do
    has_many :translations, as: :translatable, dependent: :destroy
  end

  class_methods do
    # 번역 가능한 필드 정의
    def translatable_fields(*fields)
      @translatable_fields = fields
      
      fields.each do |field|
        # 동적으로 번역된 값을 가져오는 메서드 생성
        define_method("#{field}_translated") do |locale = 'en'|
          return send(field) if locale == 'en'
          
          translation = translations.find_by(locale: locale, field_name: field.to_s)
          translation&.value.presence || send(field)
        end
      end
    end

    def get_translatable_fields
      @translatable_fields || []
    end
  end

  # 특정 언어의 모든 번역을 해시로 반환
  def translations_for(locale)
    return {} if locale == 'en'
    
    translations.where(locale: locale).each_with_object({}) do |t, hash|
      hash[t.field_name] = t.value
    end
  end

  # 번역 설정
  def set_translation(field, locale, value)
    return if locale == 'en'
    
    translation = translations.find_or_initialize_by(
      locale: locale,
      field_name: field.to_s
    )
    translation.value = value
    translation.save!
  end

  # 여러 필드의 번역을 한번에 설정
  def set_translations(locale, translations_hash)
    return if locale == 'en'
    
    translations_hash.each do |field, value|
      set_translation(field, locale, value) if value.present?
    end
  end

  # JSON 직렬화시 번역 포함
  def as_json_with_translations(locale = 'en', options = {})
    json = as_json(options)
    
    if locale != 'en'
      translations_for(locale).each do |field, value|
        json[field] = value if value.present?
      end
    end
    
    json
  end
end
