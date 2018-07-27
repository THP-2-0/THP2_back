# frozen_string_literal: true

# == Schema Information
#
# Table name: classrooms
#
#  id          :uuid             not null, primary key
#  title       :string(50)       not null
#  description :text
#  creator_id  :uuid
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

RSpec.describe Classroom, type: :model do
  it "is creatable" do
    classroom = create(:classroom)
    expect(classroom.title).not_to be_blank
    expect(classroom.description).not_to be_blank
  end

  it "follows creator link" do
    classroom = create(:classroom).reload
    expect(classroom.creator.classrooms.first).to eq(classroom)
  end

  it "follows lessons link" do
    classroom = create(:classroom, :with_lessons).reload
    expect(classroom.lessons.first.classroom).to eq(classroom)
  end

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_most(50) }
  it { is_expected.to validate_length_of(:description).is_at_most(300) }
end
