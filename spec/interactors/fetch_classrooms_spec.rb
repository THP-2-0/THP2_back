# frozen_string_literal: true

describe FetchClassrooms do
  subject do
    described_class.call(input_context)
  end

  let(:page_params) { { number: 1, size: 25 } }
  let(:input_context) { { page_params: page_params } }
  let!(:classrooms) { create_list(:classroom, 5) }

  context "with missing params" do
    in_context "pagination empty fetch params", :page_params
  end

  it "returns all the classrooms" do
    expect(subject.classrooms.size).to eq(5)
    expect(subject.classrooms.map(&:id)).to eq(classrooms.reverse.map(&:id))
  end

  describe "ordering" do
    it "orders by created_at" do
      expect(subject.classrooms.map(&:id)).to eq(classrooms.sort_by{ |e| -e.created_at.to_f }.map(&:id))
    end
  end

  describe "paginate" do
    let!(:classrooms) { create_list(:classroom, 30) }

    it "paginates" do
      expect(subject.classrooms.size).to eq(25)
    end
  end
end
