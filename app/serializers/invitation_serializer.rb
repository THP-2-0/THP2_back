# frozen_string_literal: true

class InvitationSerializer < ActiveModel::Serializer
  attributes :id, :accepted, :student_id, :teacher_id
end
