# frozen_string_literal: true

class ClassroomPolicy < ApplicationPolicy
  def update?
    record.creator == user
  end

  def destroy?
    record.creator == user
  end
end
