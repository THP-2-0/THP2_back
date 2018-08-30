# frozen_string_literal: true

describe ApplicationController do
  controller do
    def interactor_failure
      raise Interactor::Failure, Interactor::Context.new(errors: [:errors])
    end
  end

  describe "interactor_failure" do
    before do
      routes.draw { get "interactor_failure" => "anonymous#interactor_failure" }
      get :interactor_failure
    end

    it "returns forbidden" do
      expect(response).to be_forbidden
    end

    it "returns errors" do
      expect(json_response[:errors]).to eq(['errors'])
    end
  end

  describe "devise permitted params" do
    it "includes username and email" do
      subj = described_class.new
      parameters = double("devise params")
      expect(parameters).to receive(:permit).with(:sign_up, keys: %i[username email])
      expect(subj).to receive(:devise_parameter_sanitizer).and_return(parameters)
      subj.send(:configure_permitted_parameters)
    end
  end

  describe "page_params" do
    subject do
      controller.send(:page_params)
    end

    context "with no page param" do
      it "returns no number" do
        expect(subject[:number]).to be_nil
      end

      it "returns a size of 25" do
        expect(subject[:size]).to eq(25)
      end
    end

    context "with too big page size" do
      before do
        controller.params = ActionController::Parameters.new(page: { size: 800 })
      end

      it "returns 25" do
        expect(subject[:size]).to eq(25)
      end
    end

    context "with normal conditions" do
      let(:size) { Random.rand(25..100) }
      let(:number) { Random.rand(1..10) }

      before do
        controller.params = ActionController::Parameters.new(page: { size: size, number: number })
      end

      it "returns the passed numbers" do
        expect(subject.to_h).to eq("size" => size, "number" => number)
      end
    end
  end
end
