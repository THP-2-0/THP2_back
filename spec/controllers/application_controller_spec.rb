# frozen_string_literal: true

describe ApplicationController do
  describe "devise permitted params" do
    it "includes username and email" do
      subj = ApplicationController.new
      parameters = double("devise params")
      expect(parameters).to receive(:permit).with(:sign_up, keys: %i[username email])
      expect(subj).to receive(:devise_parameter_sanitizer).and_return(parameters)
      subj.send(:configure_permitted_parameters)
    end
  end
end
