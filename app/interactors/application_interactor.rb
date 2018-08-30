# frozen_string_literal: true

class ApplicationInteractor
  def self.inherited(base)
    base.instance_exec do
      include Interactor
      include Interactor::Contracts

      on_breach do |breaches|
        context.fail!(errors: breaches.flat_map(&:messages), breaches: breaches.flat_map(&:property))
      end
    end
  end
end
