# frozen_string_literal: true

class InvitationPolicy < ApplicationPolicy
  def destroy?
    record.teacher == user
  end

  def update?
    record.student == user
  end
end
