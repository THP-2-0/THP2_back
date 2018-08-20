# frozen_string_literal: true

class LessonPolicy < ApplicationPolicy
  def update?
    record.creator == user
  end

  def destroy?
    record.creator == user
  end

  def create_invitation?
    record.teacher == user
  end
end
