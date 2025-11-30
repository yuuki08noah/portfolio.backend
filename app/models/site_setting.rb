class SiteSetting < ApplicationRecord
  include Translatable
  
  translatable_fields :value

  validates :key, presence: true, uniqueness: true

  def self.get(key)
    find_by(key: key)
  end

  def self.set(key, value, value_ko = nil)
    setting = find_or_initialize_by(key: key)
    setting.value = value
    # 한국어 번역도 translations 테이블에 저장
    setting.save
    setting.set_translation(:value, 'ko', value_ko) if value_ko.present?
    setting
  end

  def value_for_locale(locale = 'en')
    value_translated(locale)
  end
end
