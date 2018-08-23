# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/invitations
require 'factory_bot'
require 'faker'
class InvitationsPreview < ActionMailer::Preview
  include FactoryBot::Syntax::Methods
  # Preview this email at http://localhost:3000/rails/mailers/invitations/create
  def create
    InvitationsMailer.create(FactoryBot.create(:invitation))
  end
end
