module Api
  module V1
    class SiteSettingsController < ApplicationController
      before_action :authenticate_user!, only: [:update, :bulk_update]

      def index
        settings = SiteSetting.all.includes(:translations)
        render json: {
          data: settings.map { |s| setting_response(s) }
        }
      end

      def show
        setting = SiteSetting.find_by(key: params[:id])
        if setting
          render json: { data: setting_response(setting) }
        else
          render json: { error: 'Setting not found' }, status: :not_found
        end
      end

      def update
        setting = SiteSetting.find_or_initialize_by(key: params[:id])
        if setting.update(setting_params)
          # 한국어 번역 저장
          if params[:translations].present? && params[:translations][:ko].present?
            setting.set_translation(:value, 'ko', params[:translations][:ko][:value])
          elsif params[:value_ko].present?
            setting.set_translation(:value, 'ko', params[:value_ko])
          end
          render json: { data: setting_response(setting) }
        else
          render json: { errors: setting.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def bulk_update
        params[:settings].each do |setting_data|
          setting = SiteSetting.find_or_initialize_by(key: setting_data[:key])
          setting.update(value: setting_data[:value])
          setting.set_translation(:value, 'ko', setting_data[:value_ko]) if setting_data[:value_ko].present?
        end
        render json: { success: true }
      end

      private

      def setting_params
        params.permit(:value)
      end

      def setting_response(setting)
        ko_translation = setting.translations_for('ko')
        {
          key: setting.key,
          value: setting.value,
          translations: {
            ko: ko_translation
          }
        }
      end
    end
  end
end
