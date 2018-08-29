# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LessonPolicy do
  subject { described_class }

  let(:user) { User.new }
  let(:created_lesson) { create(:lesson, creator: test_user) }
  let(:not_created_lesson) { create(:lesson) }

  permissions :update?, :create_invitation?, :destroy? do
    it "denies update on not created lessons" do
      expect(subject).not_to permit(test_user, not_created_lesson)
    end

    it "allows update on created lessons" do
      expect(subject).to permit(test_user, created_lesson)
    end
  end
end
