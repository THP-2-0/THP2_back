# frozen_string_literal: true

# == Schema Information
#
# Table name: lessons
#
#  id           :uuid             not null, primary key
#  title        :string(50)       not null
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  creator_id   :uuid
#  classroom_id :uuid
#

RSpec.describe Lesson, type: :model do
  it "is creatable" do
    lesson = create(:lesson)
    expect(lesson.title).not_to be_blank
    expect(lesson.description).not_to be_blank
  end

  it "follows creator link" do
    lesson = create(:lesson).reload
    expect(lesson.creator.created_lessons.first).to eq(lesson)
  end

  it "follows students link with scope" do
    lesson = create(:lesson, :with_invitations, :with_students).reload
    expect(lesson.students.first.joined_lessons.first).to eq(lesson)
    expect(lesson.students.size).to eq(Invitation.where(accepted: true).size)
  end

  it "follows invitations link" do
    lesson = create(:lesson, :with_invitations).reload
    expect(lesson.invitations.first.lesson).to eq(lesson)
  end

  it "follows classroom link" do
    lesson = create(:lesson).reload
    expect(lesson.classroom.lessons.first).to eq(lesson)
  end

  it { is_expected.to validate_presence_of(:classroom) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_most(50) }
  it { is_expected.to validate_length_of(:description).is_at_most(300) }
end
