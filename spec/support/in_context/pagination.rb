# frozen_string_literal: true

RSpec.define_context "pagination empty fetch params" do |param_name|
  context "with empty #{param_name}" do
    let(param_name.to_sym) { nil }

    it "is a failure" do
      expect(subject).to be_failure
      expect(subject.errors).not_to be_empty
      expect(subject.breaches).to eq([param_name.to_sym])
    end
  end
end

RSpec.define_context "controller paginate" do |name|
  context "when pagination is needed" do
    subject do
      get :index, params: params.merge(page: { number: number, size: size })
    end

    instanciate_context

    let(:number) { 1 }
    let(:size) { 27 }

    it "limits the number of elements" do
      subject
      expect(json_response[name].size).to eq(size)
    end

    context "when changing page" do
      let(:number) { 2 }

      it "works" do
        subject
        expect(json_response[name].size).to eq(3)
      end
    end

    it "provides pagination informations" do
      subject
      meta = json_response[:meta]

      expect(meta[:page_size]).to eq(27)
      expect(meta[:current_page]).to eq(1)
      expect(meta[:next_page]).to eq(2)
      expect(meta[:prev_page]).to be_nil
      expect(meta[:total_pages]).to eq(2)
      expect(meta[:total_count]).to eq(30)
    end
  end
end
