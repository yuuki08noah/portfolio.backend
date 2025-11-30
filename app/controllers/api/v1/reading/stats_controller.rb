module Api
  module V1
    module Reading
      class StatsController < ApplicationController
        before_action :authenticate_user!, except: [ :index ]

        def index
          books = if current_user
                    current_user.books
          else
                    Book.all
          end
          completed_this_year = books.completed.where("end_date >= ?", Date.current.beginning_of_year).count
          average_rating = books.where.not(rating: nil).average(:rating)&.to_f
          by_status = books.group(:status).count

          render json: {
            data: {
              total: books.count,
              booksThisYear: completed_this_year,
              averageRating: average_rating,
              byStatus: by_status,
              totalPages: books.where.not(pages: nil).sum(:pages)
            }
          }, status: :ok
        end
      end
    end
  end
end
