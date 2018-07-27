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
    expect(lesson.creator.lessons.first).to eq(lesson)
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
