# frozen_string_literal: true

describe FetchLessons do
  subject do
    described_class.call(input_context)
  end

  let(:classroom) { lesson_classroom }
  let(:lesson_classroom) { create(:classroom) }
  let(:page_params) { { number: 1, size: 25 } }
  let(:input_context) { { classroom: classroom, page_params: page_params } }
  let!(:lessons) { create_list(:lesson, 5, classroom: lesson_classroom) }

  context "with missing params" do
    define_context "empty fetch params" do |param_name|
      context "with empty #{param_name}" do
        let(param_name.to_sym) { nil }

        it "raises an Interactor exception" do
          expect(subject).to be_failure
          expect(subject.errors).not_to be_empty
          expect(subject.breaches).to eq([param_name.to_sym])
        end
      end
    end

    in_context "empty fetch params", :classroom
    in_context "empty fetch params", :page_params
  end

  it "returns all the lessons" do
    expect(subject.lessons.size).to eq(lessons.size)
    expect(subject.lessons.map(&:id)).to eq(lessons.reverse.map(&:id))
  end

  describe "ordering" do
    it "orders by created_at" do
      expect(subject.lessons.map(&:id)).to eq(lessons.sort_by{ |e| -e.created_at.to_f }.map(&:id))
    end
  end

  describe "paginate" do
    let!(:lessons) { create_list(:lesson, 30, classroom: lesson_classroom) }

    it "paginates" do
      expect(subject.lessons.size).to eq(25)
    end
  end

  describe "filtering" do
    let!(:other_lesson) { create(:lesson) }

    it "filters by classroom" do
      expect(subject.lessons.size).to eq(5)
    end
  end
end
