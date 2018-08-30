# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActionController::ParameterMissing, with: :rescue_param_missing
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :rescue_bad_params
  rescue_from Pundit::NotAuthorizedError, with: :render_unauthorized
  rescue_from Interactor::Failure, with: :rescue_interactor_failure

  def record_not_found(exception)
    render json: { errors: [exception.message] }, status: :not_found
  end

  def rescue_param_missing(exception)
    render json: { errors: [exception.message] }, status: :forbidden
  end

  def rescue_bad_params(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :forbidden
  end

  def rescue_interactor_failure(exception)
    render json: { errors: exception.context.errors }, status: :forbidden
  end

  def render_unauthorized
    head :unauthorized
  end

  def no_route
    head :not_found
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username email])
  end

  private

  def pagination_dict(collection)
    {
      page_size: collection.current_per_page,
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count,
    }
  end

  def filtering_params(filters)
    @filtering_params ||=
      begin
        filter_params = params.reverse_merge(filter: {})[:filter].permit(filters)
        filter_params.each do |k, v|
          case v
          when "true" then filter_params[k] = true
          when "false" then filter_params[k] = false
          when /^[0-9]+$/ then filter_params[k] = v.to_i
          when /^[0-9.]+$/ then filter_params[k] = v.to_f
          end
        end
        filter_params
      end
  end

  def page_params
    @page_params ||=
      begin
        new_page_params = params.reverse_merge(page: {})[:page].permit(:number, :size)
        new_page_params[:size] ||= 25
        new_page_params[:size] = new_page_params[:size].to_i
        new_page_params[:size] = 25 if new_page_params[:size] > 100
        new_page_params
      end
  end

  def current_classroom
    @current_classroom ||= Classroom.find(params[:classroom_id])
  end

  def current_lesson
    @current_lesson ||= Lesson.where(classroom_id: params[:classroom_id]).find(params[:lesson_id])
  end
end
