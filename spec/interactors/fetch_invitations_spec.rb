# frozen_string_literal: true

describe FetchInvitations do
  subject do
    described_class.call(input_context)
  end

  let(:lesson) { invitation_lesson }
  let(:invitation_lesson) { create(:lesson) }
  let(:page_params) { { number: 1, size: 25 } }
  let(:input_context) { { lesson: lesson, page_params: page_params } }
  let!(:invitations) { create_list(:invitation, 5, lesson: invitation_lesson) }

  context "with missing params" do
    in_context "pagination empty fetch params", :lesson
    in_context "pagination empty fetch params", :page_params
  end

  describe "ordering" do
    it "orders by created_at" do
      expect(subject.invitations.map(&:id)).to eq(invitations.sort_by{ |e| -e.created_at.to_f }.map(&:id))
    end
  end

  describe "paginate" do
    let!(:invitations) { create_list(:invitation, 30, lesson: invitation_lesson) }

    it "paginates" do
      expect(subject.invitations.size).to eq(25)
    end
  end

  describe "filtering" do
    let!(:other_invitation) { create(:invitation) }

    it "filters by lesson" do
      expect(subject.invitations.size).to eq(5)
    end
  end
end
