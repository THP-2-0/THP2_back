# frozen_string_literal: true

class ClassroomsController < ApplicationController
  before_action :authenticate_user!

  def index
    classrooms = FetchClassrooms.call!(page_params: page_params).classrooms
    render json: classrooms, meta: pagination_dict(classrooms)
  end

  def create
    new_classroom = Classroom.create!(create_params.merge(creator: current_user))
    render json: new_classroom, status: :created
  end

  def update
    authorize(current_classroom)
    current_classroom.update!(update_params)
    render json: current_classroom
  end

  def show
    render json: current_classroom
  end

  def destroy
    authorize(current_classroom)
    current_classroom.delete
    head :no_content
  end

  private

  def current_classroom
    @current_classroom ||= Classroom.find(params[:id])
  end

  def create_params
    params.require(:classroom).permit(:title, :description)
  end
  alias_method :update_params, :create_params
end
