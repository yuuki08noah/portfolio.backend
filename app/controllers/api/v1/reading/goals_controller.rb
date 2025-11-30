module Api
  module V1
    module Reading
      class GoalsController < ApplicationController
        before_action :authenticate_user!, except: [ :index ]
        before_action :set_goal, only: [ :update, :destroy ]

        def index
          goals = if current_user
                    current_user.reading_goals.order(year: :desc)
          else
                    ReadingGoal.order(year: :desc)
          end
          render json: { data: goals.map { |goal| goal_response(goal) } }, status: :ok
        end

        def create
          goal = current_user.reading_goals.new(goal_params)
          if goal.save
            render json: { message: "Reading goal created", goal: goal_response(goal) }, status: :created
          else
            render json: { errors: goal.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          if @goal.update(goal_params)
            render json: { message: "Reading goal updated", goal: goal_response(@goal) }, status: :ok
          else
            render json: { errors: @goal.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @goal.destroy
          render json: { message: "Reading goal deleted" }, status: :ok
        end

        private

        def set_goal
          @goal = current_user.reading_goals.find(params[:id])
        end

        def goal_params
          params.permit(:year, :target_books, :current_books)
        end

        def goal_response(goal)
          {
            id: goal.id.to_s,
            year: goal.year,
            targetBooks: goal.target_books,
            currentBooks: goal.current_books,
            progress: goal.progress
          }
        end
      end
    end
  end
end
