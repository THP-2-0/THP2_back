# frozen_string_literal: true

class LessonsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: Lesson.order(:created_at)
  end

  def create
    new_lesson = Lesson.create!(create_params.merge(creator: current_user, classroom: current_classroom))
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

  def current_classroom
    @current_classroom ||= Classroom.find(params[:classroom_id])
  end

  def current_lesson
    @current_lesson ||= Lesson.find(params[:id])
  end

  def create_params
    params.require(:lesson).permit(:title, :description)
  end
  alias_method :update_params, :create_params
end
