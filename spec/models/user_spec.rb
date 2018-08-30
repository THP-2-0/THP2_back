# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  allow_password_change  :boolean          default(FALSE)
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  username               :string
#  email                  :string
#  tokens                 :json
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

describe User do
  subject do
    create(:user, :confirmed)
  end

  it "is creatable" do
    create(:user)
    user = described_class.first
    expect(user.email).not_to be_blank
    expect(user.username).not_to be_blank
    expect(user.password).to be_blank
  end

  it "follows lessons link" do
    user = create(:user, :with_created_lessons).reload
    expect(user.created_lessons.first.creator).to eq(user)
  end

  it "follows classrooms link" do
    user = create(:user, :with_classrooms).reload
    expect(user.classrooms.first.creator).to eq(user)
  end

  it "follows the sent_invitations link" do
    user = create(:user, :with_sent_invitations).reload
    expect(user.sent_invitations.first.teacher).to eq(user)
  end

  it "follows the received_invitations link" do
    user = create(:user, :with_received_invitations).reload
    expect(user.received_invitations.first.student).to eq(user)
  end

  it "follows the joined_lessons link" do
    user = create(:user, :with_joined_lessons).reload
    expect(user.joined_lessons.first.students.first).to eq(user)
  end

  it "cascade destroys its lessons" do
    user = create(:user, :with_created_lessons)
    expect{ user.destroy }.to change(Lesson, :count).to(0)
  end

  it "doesn't need confirmation" do
    expect(create(:user)).not_to be_confirmation_required
  end

  describe "As devise_token_auth doesn't use serializers _sigh_" do
    it "returns the right fields in a JSON" do
      user_json = JSON.parse(subject.to_json)
      expect(user_json['id']).to eq(subject.id)
      expect(user_json['uid']).to eq(subject.uid)
      expect(user_json['email']).to eq(subject.email)
      expect(user_json['username']).to eq(subject.username)
      expect(user_json['provider']).to eq(subject.provider)
      expect(user_json['confirmed_at']).to eq(subject.confirmed_at.as_json)
    end
  end

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
end
