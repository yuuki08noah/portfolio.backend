module Localizable
  extend ActiveSupport::Concern

  included do
    before_action :set_locale
  end

  private

  def set_locale
    @locale = params[:locale] || 'en'
  end

  def current_locale
    @locale || 'en'
  end

  # Helper to get localized field from a record
  def localized_field(record, field)
    return record.send(field) if current_locale == 'en'
    
    translations = record.translations_for(current_locale)
    translations[field.to_s].presence || record.send(field)
  end

  # Helper to get all localized fields
  def localized_response(record, fields)
    result = {}
    fields.each do |field|
      result[field] = localized_field(record, field)
    end
    result
  end
end
