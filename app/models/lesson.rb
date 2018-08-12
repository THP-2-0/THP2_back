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

class Lesson < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 300 }
  validates :classroom, presence: true

  belongs_to :creator, class_name: 'User', inverse_of: 'created_lessons'
  belongs_to :classroom

  has_many :invitations, dependent: :destroy

  has_many(
    :students,
    -> { where(invitations: { accepted: true }) },
    class_name: 'User',
    through: :invitations,
    inverse_of: 'joined_lessons',
  )
end
