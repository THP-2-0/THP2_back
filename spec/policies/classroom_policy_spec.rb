# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClassroomPolicy do
  subject { described_class }

  let(:user) { User.new }
  let(:created_classroom) { create(:classroom, creator: test_user) }
  let(:not_created_classroom) { create(:classroom) }

  permissions :update?, :destroy? do
    it "denies update on not created classroom" do
      expect(subject).not_to permit(test_user, not_created_classroom)
    end

    it "allows update on created classroom" do
      expect(subject).to permit(test_user, created_classroom)
    end
  end
end
