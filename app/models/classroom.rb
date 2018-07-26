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

class Classroom < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 300 }

  belongs_to :creator, class_name: 'User', inverse_of: 'lessons'
  has_many :lessons, dependent: :destroy
end
