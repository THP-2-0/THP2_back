# frozen_string_literal: true

class FetchInvitations < ApplicationInteractor
  expects do
    required(:lesson).filled
    required(:page_params).filled
  end

  assures do
    required(:invitations).filled
  end

  def call
    context.invitations =
      Invitation.
      where(lesson: context.lesson).
      page(context.page_params[:number]).
      per(context.page_params[:size]).
      order(created_at: :desc)
  end
end
