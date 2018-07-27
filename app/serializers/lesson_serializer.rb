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

class LessonSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :created_at, :creator_id, :classroom_id
end
