# frozen_string_literal: true

# == Schema Information
#
# Table name: invitations
#
#  id         :uuid             not null, primary key
#  accepted   :boolean          default(FALSE)
#  lesson_id  :uuid
#  student_id :uuid
#  teacher_id :uuid
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

RSpec.describe Invitation, type: :model do
  it "is creatable" do
    invitation = create(:invitation).reload
    expect(invitation.id).not_to be_nil
    expect(invitation.accepted?).to be_falsy
  end

  it "follows student link" do
    invitation = create(:invitation).reload
    expect(invitation.student.received_invitations.first).to eq(invitation)
  end

  it "follows teacher link" do
    invitation = create(:invitation).reload
    expect(invitation.teacher.sent_invitations.first).to eq(invitation)
  end

  it "follows lesson link" do
    invitation = create(:invitation).reload
    expect(invitation.lesson.invitations.first).to eq(invitation)
  end

  it { is_expected.to validate_presence_of(:student) }
  it { is_expected.to validate_presence_of(:teacher) }
  it { is_expected.to validate_presence_of(:lesson) }

  context "when creating an invitation" do
    subject do
      create(:invitation)
    end

    it "sends an email" do
      expect(InvitationsMailer).to receive(:create).and_call_original
      expect{ subject }.to change{ ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
