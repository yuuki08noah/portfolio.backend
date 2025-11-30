module Api
  module V1
    module Auth
      class AuthController < ApplicationController
        # POST /api/v1/auth/register
        def register
          user = User.new(user_params)

          if user.save
            user.generate_email_verification_token!
            send_verification_email(user)
            token = encode_token(user_id: user.id)
            render json: {
              message: 'User created successfully',
              token: token,
              user: user_response(user)
            }, status: :created
          else
            Rails.logger.error("User registration failed: #{user.errors.full_messages}")
            
            if user.errors[:email].include?('has already been taken')
              render json: { error: 'Email has already been taken' }, status: :conflict
            else
              render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
            end
          end
        end

        # POST /api/v1/auth/login
        def login
          user = User.find_by(email: params[:email])
          
          if user&.authenticate(params[:password])
            user.update(last_login_at: Time.current)
            token = encode_token(user_id: user.id)
            render json: { 
              message: 'Login successful',
              token: token,
              user: user_response(user)
            }, status: :ok
          else
            render json: { error: 'Invalid email or password' }, status: :unauthorized
          end
        end

        # POST /api/v1/auth/password/reset/request
        def request_password_reset
          user = User.find_by(email: params[:email])
          if user&.generate_password_reset!
            send_password_reset_email(user)
          end

          render json: { message: 'If that account exists, a reset link was generated.' }, status: :ok
        end

        # POST /api/v1/auth/password/reset/confirm
        def confirm_password_reset
          user = User.find_by(password_reset_token: params[:token])
          return render json: { error: 'Invalid token' }, status: :not_found unless user

          if user.password_reset_expires_at.present? && user.password_reset_expires_at < Time.current
            return render json: { error: 'Token expired' }, status: :unprocessable_entity
          end

          if user.update(password: params[:password], password_confirmation: params[:password_confirmation])
            user.clear_password_reset!
            render json: { message: 'Password updated successfully' }, status: :ok
          else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # POST /api/v1/auth/verify_email
        def verify_email
          user = User.find_by(email_verification_token: params[:token])
          return render json: { error: 'Invalid token' }, status: :not_found unless user

          user.update(email_verified: true, email_verification_token: nil)
          render json: { message: 'Email verified' }, status: :ok
        end

        private

        def user_params
          params.permit(
            :email,
            :password,
            :password_confirmation,
            :name,
            :profile,
            :company,
            :job_position,
            :avatar_url,
            :phone,
            :github_url,
            :linkedin_url,
            :twitter_url,
            :website_url,
            :bio,
            :location_country,
            :location_city,
            :timezone,
            :locale,
            :currency,
            :theme_country,
            :theme_city,
            :dark_mode,
            :email_notifications
          )
        end

        def user_response(user)
          {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role,
            profile: user.profile,
            company: user.company,
            job_position: user.job_position,
            email_verified: user.email_verified,
            theme: {
              country: user.theme_country,
              city: user.theme_city,
              dark_mode: user.dark_mode
            },
            locale: user.locale,
            timezone: user.timezone,
            admin: {
              status: user.admin_status,
              invited_by: user.admin_invited_by,
              approved_by: user.admin_approved_by,
              invite_expires_at: user.admin_invite_expires_at
            }
          }
        end

        def send_verification_email(user)
          UserMailer.email_verification(user).deliver_now
        rescue StandardError => e
          Rails.logger.warn("Verification email delivery failed: #{e.message}")
        end

        def send_password_reset_email(user)
          UserMailer.password_reset(user).deliver_now
        rescue StandardError => e
          Rails.logger.warn("Password reset email delivery failed: #{e.message}")
        end
      end
    end
  end
end
