# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActionController::ParameterMissing, with: :rescue_param_missing
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :rescue_bad_params
  rescue_from Pundit::NotAuthorizedError, with: :render_unauthorized

  def record_not_found(exception)
    render json: { errors: [exception.message] }, status: :not_found
  end

  def rescue_param_missing(exception)
    render json: { errors: [exception.message] }, status: :forbidden
  end

  def rescue_bad_params(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :forbidden
  end

  def render_unauthorized
    head :unauthorized
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username email])
  end
end
