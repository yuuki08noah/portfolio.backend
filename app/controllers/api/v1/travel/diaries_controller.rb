module Api
  module V1
    module Travel
      class DiariesController < ApplicationController
        include Localizable
        before_action :authenticate_user!, except: [:index, :show]
        before_action :set_diary, only: [:show, :update, :destroy]

        def index
          diaries = if current_user
                      current_user.travel_diaries.recent
                    else
                      TravelDiary.where(is_public: true).recent
                    end
          render json: { diaries: diaries.map { |diary| diary_response(diary) } }, status: :ok
        end

        def show
          render json: { diary: diary_response(@diary) }, status: :ok
        end

        def create
          diary = current_user.travel_diaries.new(diary_params)
          if diary.save
            save_translations(diary)
            render json: { message: 'Diary created', diary: diary_response(diary) }, status: :created
          else
            render json: { errors: diary.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          if @diary.update(diary_params)
            save_translations(@diary)
            render json: { message: 'Diary updated', diary: diary_response(@diary) }, status: :ok
          else
            render json: { errors: @diary.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @diary.destroy
          render json: { message: 'Diary deleted' }, status: :ok
        end

        private

        def set_diary
          @diary = current_user.travel_diaries.find(params[:id])
        end

        def diary_params
          params.permit(
            :destination_country,
            :destination_city,
            :destination_code,
            :start_date,
            :end_date,
            :title,
            :description,
            :rating,
            :is_public,
            days: {},
            photos: [],
            expenses: {},
            companions: [],
            tags: []
          )
        end

        def save_translations(diary)
          return unless params[:translations].present?
          
          %w[ko ja].each do |locale|
            if params[:translations][locale].present?
              diary.set_translations(locale, params[:translations][locale].permit(:title, :description).to_h)
            end
          end
        end

        def diary_response(diary)
          ko_translations = diary.translations_for('ko')
          ja_translations = diary.translations_for('ja')
          
          translations_for_locale = case current_locale
                                    when 'ko' then ko_translations
                                    when 'ja' then ja_translations
                                    else {}
                                    end
          
          title = translations_for_locale['title'].presence || diary.title
          description = translations_for_locale['description'].presence || diary.description

          {
            id: diary.id,
            destination: {
              country: diary.destination_country,
              city: diary.destination_city,
              code: diary.destination_code
            },
            start_date: diary.start_date,
            end_date: diary.end_date,
            title: title,
            description: description,
            days: diary.days,
            photos: diary.photos || [],
            rating: diary.rating,
            expenses: diary.expenses,
            companions: diary.companions || [],
            tags: diary.tags || [],
            is_public: diary.is_public,
            translations: {
              ko: ko_translations,
              ja: ja_translations
            }
          }
        end
      end
    end
  end
end
