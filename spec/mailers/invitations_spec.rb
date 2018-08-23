# frozen_string_literal: true

require "rails_helper"

RSpec.describe InvitationsMailer, type: :mailer do
  describe "create" do
    let(:invitation) { build(:invitation) }
    let(:mail) { InvitationsMailer.create(invitation) }

    it "renders the headers" do
      expect(mail.subject).to eq("You have been invited to a new lesson")
      expect(mail.to).to eq([invitation.student.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Click here to join")
    end
  end
end
