module Api
  module V1
    module Portfolio
      class MilestonesController < ApplicationController
        before_action :authenticate_user!, except: [:index, :show]
        before_action :set_milestone, only: [:show]
        before_action :set_owned_milestone, only: [:update, :destroy]

        def index
          milestones = Milestone.recent
          render json: { milestones: milestones.map { |milestone| milestone_response(milestone) } }, status: :ok
        end

        def show
          render json: { milestone: milestone_response(@milestone) }, status: :ok
        end

        def create
          milestone = current_user.milestones.new(milestone_params)
          if milestone.save
            render json: { message: 'Milestone created successfully', milestone: milestone_response(milestone) }, status: :created
          else
            render json: { errors: milestone.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          if @milestone.update(milestone_params)
            render json: { message: 'Milestone updated successfully', milestone: milestone_response(@milestone) }, status: :ok
          else
            render json: { errors: @milestone.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @milestone.destroy
          render json: { message: 'Milestone deleted successfully' }, status: :ok
        end

        private

        def milestone_params
          params.permit(
            :milestone_type, :title, :organization, :period, :location,
            details: [],
            translations: {
              ko: [:title, :organization, :details],
              ja: [:title, :organization, :details]
            }
          )
        end

        def milestone_response(milestone)
          {
            id: milestone.id,
            type: milestone.milestone_type,
            title: milestone.title,
            organization: milestone.organization,
            period: milestone.period,
            details: milestone.details,
            location: milestone.location
          }
        end

        def set_milestone
          @milestone = Milestone.find(params[:id])
        end

        def set_owned_milestone
          @milestone = current_user.milestones.find(params[:id])
        end
      end
    end
  end
end
