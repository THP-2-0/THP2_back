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

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { "#{Faker::Name.first_name}##{Random.rand(10_000)}" }
    password { Faker::Internet.password }
    provider "email"
    uid "123"

    trait :confirmed do
      confirmed_at { 2.days.ago }
    end

    trait :with_lessons do
      after(:create) do |user|
        create_list(:lesson, Random.rand(1..4), creator: user)
      end
    end
  end
end
