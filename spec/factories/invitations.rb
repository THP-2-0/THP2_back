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

FactoryBot.define do
  factory :invitation do
    accepted false
    student { create(:user) }
    teacher { create(:user) }
    lesson { create(:lesson) }

    trait(:accepted) do
      accepted true
    end
  end
end
