# frozen_string_literal: true

class ApplicationInteractor
  def self.inherited(base)
    base.instance_exec do
      include Interactor
      include Interactor::Contracts

      on_breach do |breaches|
        context.fail!(breaches)
      end
    end
  end
end
