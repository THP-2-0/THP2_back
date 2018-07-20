# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # TODO: This is not used for now. Uncomment at first scope.
  # class Scope
  #   attr_reader :user, :scope

  #   def initialize(user, scope)
  #     @user = user
  #     @scope = scope
  #   end
  # end
end
