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

FactoryBot.define do
  factory :classroom do
    creator { create(:user) }

    title { Faker::Lovecraft.tome.first(50) }
    description { Faker::Matz.quote.first(300) }

    trait(:with_lessons) do
      after(:create) do |classroom|
        create_list(:lesson, Random.rand(1..4), classroom: classroom, creator: classroom.creator)
      end
    end
  end
end
