# frozen_string_literal: true

class InvitationsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: Invitation.where(lesson: current_lesson).order(:created_at)
  end

  def show
    render json: current_invitation
  end

  def update
    authorize(current_invitation)
    unless update_params[:accepted] == "true" || update_params[:accepted] == true
      return render(
        json: { errors: ["You can only accept an invitation"] },
        status: :forbidden
      )
    end
    render json: current_invitation.update(update_params)
  end

  def destroy
    authorize(current_invitation)
    current_invitation.destroy
    head :no_content
  end

  def create
    authorize(current_lesson, :create_invitation?)
    current_student = User.find(create_params[:student_id])
    render json: Invitation.create!(teacher: current_user, lesson: current_lesson, student: current_student), status: :created
  end

  private

  def current_invitation
    @current_invitation ||= Invitation.where(lesson_id: params[:lesson_id]).find(params[:id])
  end

  def create_params
    @create_params ||= params.require(:invitation).permit(:student_id)
  end

  def update_params
    @update_params ||= params.require(:invitation).permit(:accepted)
  end
end
