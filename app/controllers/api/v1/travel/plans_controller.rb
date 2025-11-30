module Api
  module V1
    module Travel
      class PlansController < ApplicationController
        before_action :authenticate_user!
        before_action :set_plan, only: [:show, :update, :destroy]

        def index
          plans = current_user.travel_plans.recent
          render json: { plans: plans.map { |plan| plan_response(plan) } }, status: :ok
        end

        def show
          render json: { plan: plan_response(@plan) }, status: :ok
        end

        def create
          plan = current_user.travel_plans.new(plan_params)
          if plan.save
            save_translations(plan)
            render json: { message: 'Plan created', plan: plan_response(plan) }, status: :created
          else
            render json: { errors: plan.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          if @plan.update(plan_params)
            save_translations(@plan)
            render json: { message: 'Plan updated', plan: plan_response(@plan) }, status: :ok
          else
            render json: { errors: @plan.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @plan.destroy
          render json: { message: 'Plan deleted' }, status: :ok
        end

        private

        def set_plan
          @plan = current_user.travel_plans.find(params[:id])
        end

        def plan_params
          params.permit(
            :destination_country,
            :destination_city,
            :destination_code,
            :target_date,
            :duration,
            :budget_amount,
            :budget_currency,
            :status,
            :time_slot_duration,
            :notes,
            checklist: {},
            bucket_list: [],
            itinerary: {}
          )
        end

        def save_translations(plan)
          return unless params[:translations].present?
          
          %w[ko ja].each do |locale|
            if params[:translations][locale].present?
              plan.set_translations(locale, params[:translations][locale].permit(:destination_city, :destination_country, :notes).to_h)
            end
          end
        end

        def plan_response(plan)
          ko_translations = plan.translations_for('ko')
          ja_translations = plan.translations_for('ja')
          
          {
            id: plan.id,
            destination: {
              country: plan.destination_country,
              city: plan.destination_city,
              code: plan.destination_code
            },
            target_date: plan.target_date,
            duration: plan.duration,
            budget: {
              amount: plan.budget_amount,
              currency: plan.budget_currency
            },
            status: plan.status,
            checklist: plan.checklist,
            bucket_list: plan.bucket_list || [],
            itinerary: plan.itinerary,
            time_slot_duration: plan.time_slot_duration,
            notes: plan.notes,
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
