module Api
  module V1
    module Admin
      class AccountsController < ApplicationController
        before_action :authenticate_user!, except: [:accept]
        before_action :authenticate_admin!, except: [:accept]
        before_action :set_admin_account, only: [:approve, :reject, :update_status]

        # GET /api/v1/admin/accounts
        def index
          admins = User.where(role: %w[admin super_admin])
          admins = admins.where(admin_status: params[:status]) if params[:status].present?

          render json: { admins: admins.map { |admin| admin_response(admin) } }, status: :ok
        end

        # POST /api/v1/admin/accounts/invite
        def invite
          email = params[:email].to_s.downcase.strip
          name = params[:name].presence || email.split('@').first
          role = params[:role].presence || 'admin'

          return render json: { error: 'Invalid role' }, status: :unprocessable_entity unless User::ROLES.include?(role)
          return render json: { error: 'Email is required' }, status: :unprocessable_entity if email.blank?
          return render json: { error: 'User with this email already exists' }, status: :unprocessable_entity if User.exists?(email: email)

          invite_token = SecureRandom.hex(16)
          expires_at = 72.hours.from_now

          admin = User.new(
            email: email,
            name: name,
            password: SecureRandom.hex(12), # temporary until accepted
            role: role,
            admin_status: 'pending',
            admin_invite_token: invite_token,
            admin_invite_expires_at: expires_at,
            admin_invited_by: current_user.id,
            admin_approved_by: []
          )

          if admin.save
            render json: { admin: admin_response(admin) }, status: :created
          else
            render json: { errors: admin.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # POST /api/v1/admin/accounts/:id/approve
        def approve
          approved_by = Array(@admin.admin_approved_by).map(&:to_i)
          approved_by |= [current_user.id]

          if @admin.update(admin_status: 'active', admin_approved_by: approved_by, admin_status_reason: params[:reason])
            render json: { admin: admin_response(@admin) }, status: :ok
          else
            render json: { errors: @admin.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # POST /api/v1/admin/accounts/:id/reject
        def reject
          if @admin.update(admin_status: 'rejected', admin_status_reason: params[:reason])
            render json: { admin: admin_response(@admin) }, status: :ok
          else
            render json: { errors: @admin.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PUT /api/v1/admin/accounts/:id/status
        def update_status
          status = params[:status]
          unless User::ADMIN_STATUSES.include?(status)
            return render json: { error: 'Invalid status' }, status: :unprocessable_entity
          end

          if @admin.update(admin_status: status, admin_status_reason: params[:reason])
            render json: { admin: admin_response(@admin) }, status: :ok
          else
            render json: { errors: @admin.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # POST /api/v1/admin/accounts/accept
        # Public endpoint for invited admins to finalize their account
        def accept
          admin = User.find_by(admin_invite_token: params[:token])
          return render json: { error: 'Invalid invite token' }, status: :not_found unless admin

          if admin.admin_invite_expires_at.present? && admin.admin_invite_expires_at < Time.current
            return render json: { error: 'Invite expired' }, status: :unprocessable_entity
          end

          if admin.update(
            name: params[:name].presence || admin.name,
            password: params[:password],
            password_confirmation: params[:password_confirmation],
            admin_status: 'active',
            admin_invite_token: nil,
            admin_invite_expires_at: nil
          )
            render json: { message: 'Admin invite accepted', admin: admin_response(admin) }, status: :ok
          else
            render json: { errors: admin.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def set_admin_account
          @admin = User.find(params[:id])
          return if @admin.admin?

          render json: { error: 'Not an admin account' }, status: :unprocessable_entity and return
        end

        def admin_response(user)
          {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role,
            admin_status: user.admin_status,
            admin_invited_by: user.admin_invited_by,
            admin_approved_by: Array(user.admin_approved_by),
            admin_invite_token: user.admin_invite_token,
            admin_invite_expires_at: user.admin_invite_expires_at,
            admin_status_reason: user.admin_status_reason,
            last_login_at: user.last_login_at
          }
        end
      end
    end
  end
end
