# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LessonPolicy do
  let(:user) { User.new }
  let(:created_lesson) { create(:lesson, creator: test_user) }
  let(:not_created_lesson) { create(:lesson) }

  subject { described_class }

  permissions :update? do
    it "denies update on not created lessons" do
      expect(subject).not_to permit(test_user, not_created_lesson)
    end

    it "allows update on created lessons" do
      expect(subject).to permit(test_user, created_lesson)
    end
  end

  permissions :destroy? do
    it "denies destroy on not created lessons" do
      expect(subject).not_to permit(test_user, not_created_lesson)
    end
    it "allows destroy on created lessons" do
      expect(subject).to permit(test_user, created_lesson)
    end
  end
end
