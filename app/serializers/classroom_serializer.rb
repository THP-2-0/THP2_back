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

class ClassroomSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :created_at, :creator_id
  attribute(:lessons) { object.lessons.pluck(:id) }
end
