# frozen_string_literal: true

class InvitationsMailer < ApplicationMailer
  def create(invitation)
    @invitation_id = invitation.id

    mail to: invitation.student.email, subject: 'You have been invited to a new lesson'
  end
end
