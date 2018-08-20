# frozen_string_literal: true

module InContext
  def self.included(base)
    base.extend ClassMethods
  end

  def self.contexts
    @contexts ||= ActiveSupport::HashWithIndifferentAccess.new
  end

  def self.add_context(context_name, &block)
    contexts[context_name] = block
  end

  def self.find_context(context_name)
    contexts[context_name] || raise("No context found with name #{context_name}")
  end

  module ClassMethods
    def in_context(context_name, *args, &block)
      Thread.current[:test_block] = block
      instance_exec(*args, &InContext.find_context(context_name))
    end

    def execute_tests
      instance_exec(&Thread.current[:test_block]) if Thread.current[:test_block]
    end
  end
end

class Object
  def define_context(context_name, &block)
    InContext.add_context(context_name, &block)
  end
end
