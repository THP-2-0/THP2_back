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

class InvitationSerializer < ActiveModel::Serializer
  attributes :id, :accepted, :student_id, :teacher_id
end
