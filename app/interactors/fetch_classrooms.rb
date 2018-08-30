# frozen_string_literal: true

class FetchClassrooms < ApplicationInteractor
  expects do
    required(:page_params).filled
  end

  assures do
    required(:classrooms).filled
  end

  def call
    context.classrooms =
      Classroom.
      includes(:lessons).
      references(:lessons).
      page(context.page_params[:number]).
      per(context.page_params[:size]).
      order(created_at: :desc)
  end
end
