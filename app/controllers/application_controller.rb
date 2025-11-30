class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def current_user
    return @current_user if defined?(@current_user)

    token = request.headers['Authorization']&.split&.last
    Rails.logger.info "Auth token present: #{token.present?}"
    return @current_user = nil if token.blank?

    begin
      decoded = JWT.decode(token, jwt_secret, true, algorithm: 'HS256').first
      Rails.logger.info "Decoded JWT: #{decoded.inspect}"
      @current_user = User.find_by(id: decoded['user_id'])
      Rails.logger.info "Current user: #{@current_user&.email}"
    rescue JWT::DecodeError => e
      Rails.logger.error "JWT decode error: #{e.message}"
      @current_user = nil
    end
  end

  def authenticate_user!
    return if current_user

    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def authenticate_admin!
    Rails.logger.info "authenticate_admin! - current_user: #{current_user&.email}, admin?: #{current_user&.admin?}"
    return if current_user&.admin?

    render json: { error: 'Forbidden' }, status: :forbidden
  end

  def encode_token(payload)
    JWT.encode(payload, jwt_secret, 'HS256')
  end

  def jwt_secret
    Rails.application.credentials.secret_key_base || Rails.application.secret_key_base
  end

  def render_not_found(error)
    render json: { error: error.message }, status: :not_found
  end
end
