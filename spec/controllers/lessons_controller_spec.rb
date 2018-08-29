# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LessonsController, type: :controller do
  let!(:classroom) { create(:classroom, creator: test_user) }

  describe "#index" do
    subject { get :index, params: { classroom_id: classroom.id } }

    in_context :authenticated do
      let!(:lessons) { create_list(:lesson, 5, classroom: classroom) }

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
    subject { get(:show, params: { classroom_id: classroom.id, id: id }) }

    let(:lesson) { create(:lesson, classroom: classroom) }
    let(:id) { lesson.id }

    in_context :authenticated do
      context "when the id doesn't exist" do
        let(:id) { Faker::Lorem.word }

        it "returns a 404" do
          subject
          expect(response).to be_not_found
        end
      end

      context "when the id exists" do
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
          expect(json_response["classroom_id"]).to eq(lesson.classroom_id)
        end
      end
    end
  end

  describe "#delete" do
    subject { delete(:destroy, params: { classroom_id: classroom.id, id: id }) }

    let!(:lesson) { create(:lesson, creator: creator, classroom: classroom) }
    let(:id) { lesson.id }
    let(:creator) { test_user }

    in_context :authenticated do
      context "when the id doesn't exist" do
        let(:id) { Faker::Lorem.word }

        it "returns a 404" do
          subject
          expect(response).to be_not_found
        end
      end

      context "when id exists" do
        context "when user is not the creator" do
          let(:creator) { create(:user) }

          it "returns an unauthorized" do
            subject
            expect(response).to be_unauthorized
          end
        end

        context "when user is the creator" do
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
    subject { post(:create, params: { classroom_id: classroom.id, lesson: params }) }

    let(:params) do
      {
        title: title,
        description: description
      }
    end
    let(:title) { Faker::Lorem.word }
    let(:description) { Faker::DrWho.quote.first(300) }

    in_context :authenticated do
      context "when classroom is not his" do
        let(:classroom) { create(:classroom) }

        it 'returns a 401' do
          subject
          expect(response).to be_unauthorized
        end
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

      context "without lesson in params" do
        subject { post(:create, params: { classroom_id: classroom.id }) }

        it "returns a 403" do
          subject
          expect(response).to be_forbidden
        end

        it "returns a readable error" do
          subject
          expect(json_response[:errors].first).to include("lesson")
        end
      end

      context "when classroom doesn't exist" do
        subject { post(:create, params: { classroom_id: "1pl4y-pok3m0n-g0-3v3ryd4y", lesson: params }) }

        it "returns a 404" do
          subject
          expect(response).to be_not_found
        end

        it "returns a readable error" do
          subject
          expect(json_response[:errors].first).to include("Classroom")
        end
      end

      context "without title" do
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

      context "when title is too long" do
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

      context "when description is too long" do
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
    subject { patch(:update, params: { classroom_id: classroom.id, id: id, lesson: params }) }

    let(:params) do
      {
        title: title,
        description: description
      }
    end
    let!(:lesson) { create(:lesson, creator: creator, classroom: classroom) }
    let(:title) { Faker::Lorem.word }
    let(:description) { Faker::StarWars.quote.first(300) }
    let(:id) { lesson.id }
    let(:creator) { test_user }

    in_context :authenticated do
      context "when the user isn't the creator" do
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

      context "when the id doesn't exist" do
        let(:id) { Faker::Lorem.word }

        it "returns a 404" do
          subject
          expect(response).to be_not_found
        end
      end

      context "without lesson in params" do
        subject { patch(:update, params: { id: id, classroom_id: classroom.id }) }

        it "returns a 403" do
          subject
          expect(response).to be_forbidden
        end

        it "returns a readable error" do
          subject
          expect(json_response[:errors].first).to include("lesson")
        end
      end

      context "when title is too long" do
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

      context "when description is too long" do
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
