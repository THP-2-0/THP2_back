# frozen_string_literal: true

class ClassroomPolicy < ApplicationPolicy
  def create_lesson?
    record.creator == user
  end

  def update?
    record.creator == user
  end

  def destroy?
    record.creator == user
  end
end
