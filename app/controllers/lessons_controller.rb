# frozen_string_literal: true

class LessonsController < ApplicationController
  before_action :authenticate_user!

  def index
    lessons = FetchLessons.call!(
      classroom: current_classroom,
      page_params: page_params,
      filters: filtering_params(:title)
    ).lessons
    render json: lessons, meta: pagination_dict(lessons)
  end

  def create
    authorize(current_classroom, :create_lesson?)
    new_lesson = Lesson.create!(create_params.merge(creator: current_user, teacher: current_user, classroom: current_classroom))
    render json: new_lesson, status: :created
  end

  def update
    authorize(current_lesson)
    current_lesson.update!(update_params)
    render json: current_lesson
  end

  def show
    render json: current_lesson
  end

  def destroy
    authorize(current_lesson)
    current_lesson.delete
    head :no_content
  end

  private

  def current_lesson
    @current_lesson ||= Lesson.where(classroom_id: params[:classroom_id]).find(params[:id])
  end

  def create_params
    params.require(:lesson).permit(:title, :description)
  end
  alias_method :update_params, :create_params
end
