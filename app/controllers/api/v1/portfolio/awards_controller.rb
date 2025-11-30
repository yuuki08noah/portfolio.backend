module Api
  module V1
    module Portfolio
      class AwardsController < ApplicationController
        before_action :authenticate_user!, except: [:index, :show]
        before_action :set_award, only: [:show]
        before_action :set_owned_award, only: [:update, :destroy]

        def index
          awards = Award.recent
          render json: { awards: awards.map { |award| award_response(award) } }, status: :ok
        end

        def show
          render json: { award: award_response(@award) }, status: :ok
        end

        def create
          award = current_user.awards.new(award_params)
          if award.save
            render json: { message: 'Award created successfully', award: award_response(award) }, status: :created
          else
            render json: { errors: award.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          if @award.update(award_params)
            render json: { message: 'Award updated successfully', award: award_response(@award) }, status: :ok
          else
            render json: { errors: @award.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @award.destroy
          render json: { message: 'Award deleted successfully' }, status: :ok
        end

        private

        def award_params
          params.permit(:title, :organization, :date, :description, :badge_image)
        end

        def award_response(award)
          {
            id: award.id,
            title: award.title,
            organization: award.organization,
            date: award.date,
            description: award.description,
            badge_image: award.badge_image
          }
        end

        def set_award
          @award = Award.find(params[:id])
        end

        def set_owned_award
          @award = current_user.awards.find(params[:id])
        end
      end
    end
  end
end
