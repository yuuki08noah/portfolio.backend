module Api
  module V1
    module Users
      class UsersController < ApplicationController
        before_action :authenticate_user!
        before_action :set_user, only: [:show, :update, :destroy, :upload_avatar]
        before_action :authorize_user!, only: [:update, :destroy, :upload_avatar]

        # GET /api/v1/users/me
        def me
          render json: { user: user_response(current_user) }, status: :ok
        end

        # GET /api/v1/users/:id
        def show
          render json: { user: user_response(@user) }, status: :ok
        end

        # PUT /api/v1/users/:id
        def update
          if @user.update(user_params)
            render json: { 
              message: 'User updated successfully',
              user: user_response(@user)
            }, status: :ok
          else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/users/:id
        def destroy
          @user.destroy
          render json: { message: 'User deleted successfully' }, status: :ok
        end

        # POST /api/v1/users/:id/avatar
        def upload_avatar
          if params[:avatar].present?
            # Purge old avatar if exists (removes from S3)
            @user.avatar.purge if @user.avatar.attached?
            
            # Generate consistent filename based on user email
            file = params[:avatar]
            extension = File.extname(file.original_filename)
            sanitized_email = @user.email.gsub(/[^a-zA-Z0-9]/, '_')
            custom_filename = "avatar_#{sanitized_email}#{extension}"
            
            # Attach with custom filename
            @user.avatar.attach(
              io: file.tempfile,
              filename: custom_filename,
              content_type: file.content_type
            )
            
            avatar_url = if @user.avatar.attached?
              @user.avatar.url
            else
              nil
            end
            
            render json: {
              message: 'Avatar uploaded successfully',
              avatar_url: avatar_url
            }, status: :ok
          else
            render json: { error: 'No avatar file provided' }, status: :unprocessable_entity
          end
        end

        private

        def set_user
          @user = User.find(params[:id])
        end

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
          avatar_url = if user.avatar.attached?
            user.avatar.url
          else
            user.avatar_url
          end
          
          {
            id: user.id,
            email: user.email,
            name: user.name,
            profile: user.profile,
            company: user.company,
            job_position: user.job_position,
            avatar_url: avatar_url,
            bio: user.bio,
            location: {
              country: user.location_country,
              city: user.location_city
            },
            social: {
              github: user.github_url,
              linkedin: user.linkedin_url,
              twitter: user.twitter_url,
              website: user.website_url
            },
            role: user.role,
            admin: {
              status: user.admin_status,
              invited_by: user.admin_invited_by,
              approved_by: user.admin_approved_by,
              invite_expires_at: user.admin_invite_expires_at
            },
            preferences: {
              locale: user.locale,
              timezone: user.timezone,
              currency: user.currency,
              theme_country: user.theme_country,
              theme_city: user.theme_city,
              dark_mode: user.dark_mode,
              email_notifications: user.email_notifications
            }
          }
        end

        def authorize_user!
          # User ID 1 (portfolio owner) can only be modified by admins
          if @user.id == 1
            return if current_user&.admin?
            render json: { error: 'Forbidden. Only admins can modify portfolio owner.' }, status: :forbidden
            return
          end

          return if @user == current_user
          return if current_user&.admin?

          render json: { error: 'Forbidden' }, status: :forbidden
        end
      end
    end
  end
end
