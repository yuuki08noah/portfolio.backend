module Api
  module V1
    class HireController < ApplicationController
      def submit
        hire_request = HireRequest.new(hire_params)

        if hire_request.save
          dispatch_email(hire_request)
          render json: { message: 'Hire request sent' }, status: :created
        else
          render json: { errors: hire_request.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def hire_params
        params.permit(:name, :company, :email, :message, :schedule_iso)
      end

      def dispatch_email(hire_request)
        HireMailer.new_request(hire_request).deliver_now
        hire_request.update(status: 'sent')
      rescue StandardError => e
        Rails.logger.warn("Hire mail delivery failed: #{e.message}")
        hire_request.update(status: 'failed')
      end
    end
  end
end
