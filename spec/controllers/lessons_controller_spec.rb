# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LessonsController, type: :controller do
  describe "#index" do
    subject { get :index }

    it "fails with a 401" do
      subject
      expect(response).to be_unauthorized
    end

    context "the user is logged" do
      before do
        auth_me_please
      end

      let!(:lessons) { create_list(:lesson, 5) }

      it "returns all the lessons" do
        subject
        expect(json_response.size).to eq(5)
        expect(json_response.first[:id]).to be_in(lessons.map(&:id))
      end

      it "returns a 200" do
        subject
        expect(response).to be_ok
      end
    end
  end

  describe "#show" do
    subject { get(:show, params: { id: id }) }
    let(:lesson) { create(:lesson) }
    let(:id) { lesson.id }

    it "fails with a 401" do
      subject
      expect(response).to be_unauthorized
    end

    context "the user is logged" do
      before do
        auth_me_please
      end

      context "if the id doesn't exist" do
        let(:id) { Faker::Lorem.word }

        it "returns a 404" do
          subject
          expect(response).to be_not_found
        end
      end

      context "if the id exists" do
        it "returns a 200" do
          subject
          expect(response).to be_ok
        end

        it "returns the lesson" do
          subject
          expect(json_response[:id]).to eq(lesson.id)
          expect(json_response[:title]).to eq(lesson.title)
          expect(json_response[:description]).to eq(lesson.description)
          expect(json_response["created_at"]).to eq(lesson.created_at.as_json)
          expect(json_response["creator_id"]).to eq(lesson.creator_id)
        end
      end
    end
  end

  describe "#delete" do
    subject { delete(:destroy, params: { id: id }) }
    let!(:lesson) { create(:lesson, creator: creator) }
    let(:id) { lesson.id }
    let(:creator) { test_user }

    it "fails with a 401" do
      subject
      expect(response).to be_unauthorized
    end

    context "the user is logged" do
      before do
        auth_me_please
      end

      context "if the id doesn't exist" do
        let(:id) { Faker::Lorem.word }

        it "returns a 404" do
          subject
          expect(response).to be_not_found
        end
      end

      context "the id exists" do
        context "the user is not the creator" do
          let(:creator) { create(:user) }

          it "returns an unauthorized" do
            subject
            expect(response).to be_unauthorized
          end
        end
        context "the user is the creator" do
          it "returns a 204" do
            subject
            expect(response).to be_no_content
          end

          it "destroys the lesson" do
            expect{ subject }.to change(Lesson, :count).by(-1)
          end
        end
      end
    end
  end

  describe "#create" do
    subject { post(:create, params: { lesson: params }) }
    let(:params) do
      {
        title: title,
        description: description
      }
    end
    let(:title) { Faker::Lorem.word }
    let(:description) { Faker::DrWho.quote.first(300) }

    it "fails with a 401" do
      subject
      expect(response).to be_unauthorized
    end

    context "the user is logged" do
      before do
        auth_me_please
      end

      it "returns a 201" do
        subject
        expect(response).to be_created
      end

      it "returns the new lesson" do
        subject
        expect(json_response[:id]).not_to be_blank
      end

      it "creates the lesson" do
        expect{ subject }.to change(Lesson, :count).by(1)
      end

      it "sets the creator to current_user" do
        subject
        expect(json_response[:creator_id]).to eq(test_user.id)
      end

      context "lesson is missing from params" do
        subject { post(:create) }

        it "returns a 403" do
          subject
          expect(response).to be_forbidden
        end

        it "returns a readable error" do
          subject
          expect(json_response[:errors].first).to include("lesson")
        end
      end

      context "if title is missing" do
        before do
          params.delete(:title)
        end

        it "returns a 403" do
          subject
          expect(response).to be_forbidden
        end

        it "returns a readable error" do
          subject
          expect(json_response[:errors].first).to include("Title")
        end
      end

      context "if title is too long" do
        let(:title) { Faker::Lorem.sentence(40).first(60) }

        it "returns a 403" do
          subject
          expect(response).to be_forbidden
        end

        it "returns a readable error" do
          subject
          expect(json_response[:errors].first).to include("Title")
        end
      end

      context "if description is too long" do
        let(:description) { Faker::Lorem.sentence(400).first(400) }

        it "returns a 403" do
          subject
          expect(response).to be_forbidden
        end

        it "returns a readable error" do
          subject
          expect(json_response[:errors].first).to include("Description")
        end
      end
    end
  end

  describe "#update" do
    subject { patch(:update, params: { id: id, lesson: params }) }
    let(:params) do
      {
        title: title,
        description: description
      }
    end
    let!(:lesson) { create(:lesson, creator: creator) }
    let(:title) { Faker::Lorem.word }
    let(:description) { Faker::StarWars.quote.first(300) }
    let(:id) { lesson.id }
    let(:creator) { test_user }

    it "fails with a 401" do
      subject
      expect(response).to be_unauthorized
    end

    context "the user is logged" do
      before do
        auth_me_please
      end

      context "the user isn't the creator" do
        let(:creator) { create(:user) }

        it "returns unauthorized" do
          subject
          expect(response).to be_unauthorized
        end
      end

      it "returns a 200" do
        subject
        expect(response).to be_ok
      end

      it "returns the updated lesson" do
        subject
        expect(json_response[:title]).to eq title
        expect(json_response[:description]).to eq description
      end

      it "updates the lesson" do
        expect{ subject }.to change{ lesson.reload.title }.to(title).and(
          change{ lesson.reload.description }.to(description)
        )
      end

      context "if the id doesn't exist" do
        let(:id) { Faker::Lorem.word }

        it "returns a 404" do
          subject
          expect(response).to be_not_found
        end
      end

      context "lesson is missing from params" do
        subject { patch(:update, params: { id: id }) }

        it "returns a 403" do
          subject
          expect(response).to be_forbidden
        end

        it "returns a readable error" do
          subject
          expect(json_response[:errors].first).to include("lesson")
        end
      end

      context "if title is too long" do
        let(:title) { Faker::Lorem.sentence(40).first(60) }

        it "returns a 403" do
          subject
          expect(response).to be_forbidden
        end

        it "returns a readable error" do
          subject
          expect(json_response[:errors].first).to include("Title")
        end
      end

      context "if description is too long" do
        let(:description) { Faker::Lorem.sentence(400).first(400) }

        it "returns a 403" do
          subject
          expect(response).to be_forbidden
        end

        it "returns a readable error" do
          subject
          expect(json_response[:errors].first).to include("Description")
        end
      end
    end
  end
end
