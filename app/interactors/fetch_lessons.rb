# frozen_string_literal: true

class FetchLessons < ApplicationInteractor
  expects do
    required(:classroom).filled
    required(:page_params).filled
  end

  assures do
    required(:lessons).filled
  end

  def call
    context.lessons =
      Lesson.
      where(classroom: context.classroom).
      page(context.page_params[:number]).
      per(context.page_params[:size]).
      order(:created_at)
  end
end
