module Api
  module V1
    module Travel
      class StatsController < ApplicationController
        include Localizable
        
        def index
          # Get diaries for stats (public if not logged in, all if logged in)
          diaries = if current_user
                      current_user.travel_diaries
                    else
                      TravelDiary.where(is_public: true)
                    end
          
          # Get plans for upcoming trip
          plans = current_user&.travel_plans&.where(status: ['planning', 'booked'])&.order(target_date: :asc)
          
          # Calculate stats
          countries = diaries.pluck(:destination_country).compact.uniq
          completed_trips = diaries.count
          
          # Calculate total days traveled
          days_traveled = diaries.sum do |diary|
            next 0 unless diary.start_date && diary.end_date
            (diary.end_date - diary.start_date).to_i + 1
          end
          
          # Get next trip
          next_trip = plans&.first
          next_trip_destination = next_trip ? next_trip.destination_city : nil
          
          render json: {
            stats: {
              countries_visited: countries.count,
              trips_completed: completed_trips,
              days_traveled: days_traveled,
              next_trip: next_trip_destination,
              countries_list: countries
            }
          }, status: :ok
        end
      end
    end
  end
end
