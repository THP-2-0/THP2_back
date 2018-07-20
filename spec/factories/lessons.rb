# frozen_string_literal: true

# == Schema Information
#
# Table name: lessons
#
#  id          :uuid             not null, primary key
#  title       :string(50)       not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  creator_id  :uuid
#

FactoryBot.define do
  factory :lesson do
    creator { create(:user) }

    title { Faker::Lovecraft.tome.first(50) }
    description { Faker::Matz.quote.first(300) }
  end
end
