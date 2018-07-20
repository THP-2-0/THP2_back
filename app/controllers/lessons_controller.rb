# frozen_string_literal: true

class LessonsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: Lesson.all
  end

  def create
    lesson = Lesson.create!(create_params.merge(creator: current_user))
    render json: lesson, status: :created
  end

  def update
    lesson = Lesson.find(params[:id])
    lesson.update!(update_params)
    render json: lesson
  end

  def show
    render json: Lesson.find(params[:id])
  end

  def destroy
    Lesson.find(params[:id]).delete
    head :no_content
  end

  private

  def create_params
    params.require(:lesson).permit(:title, :description)
  end
  alias_method :update_params, :create_params
end
