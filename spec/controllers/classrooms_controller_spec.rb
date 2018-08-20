# frozen_string_literal: true

describe ClassroomsController do
  define_context "inexistant classroom" do
    context "if the id doesn't exist" do
      let(:id) { Faker::Lorem.word }

      it "returns a 404" do
        subject
        expect(response).to be_not_found
      end
    end
  end

  describe "#index" do
    subject { get :index }

    in_context :authenticated do
      let!(:classrooms) { create_list(:classroom, 5) }

      it "returns all the classrooms" do
        subject
        expect(json_response.size).to eq(5)
        expect(json_response.first[:id]).to be_in(classrooms.map(&:id))
      end

      it "returns a 200" do
        subject
        expect(response).to be_ok
      end
    end
  end

  describe "#show" do
    subject { get(:show, params: { id: id }) }
    let(:classroom) { create(:classroom) }
    let(:id) { classroom.id }

    in_context :authenticated do
      in_context "inexistant classroom"

      context "if the id exists" do
        it "returns a 200" do
          subject
          expect(response).to be_ok
        end

        it "returns the classroom" do
          subject
          expect(json_response[:id]).to eq(classroom.id)
          expect(json_response[:title]).to eq(classroom.title)
          expect(json_response[:description]).to eq(classroom.description)
          expect(json_response["created_at"]).to eq(classroom.created_at.as_json)
          expect(json_response["creator_id"]).to eq(classroom.creator_id)
        end

        context "the classroom has lessons" do
          let(:classroom) { create(:classroom, :with_lessons) }
          it "returns the lesson ids" do
            subject
            expect(json_response["lessons"]).to eq(classroom.lessons.sort_by(&:created_at).map(&:id))
          end
        end
      end
    end
  end

  describe "#delete" do
    subject { delete(:destroy, params: { id: id }) }
    let!(:classroom) { create(:classroom, creator: creator) }
    let(:id) { classroom.id }
    let(:creator) { test_user }

    in_context :authenticated do
      in_context "inexistant classroom"

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

          it "destroys the classroom" do
            expect{ subject }.to change(Classroom, :count).by(-1)
          end
        end
      end
    end
  end

  describe "#create" do
    subject { post(:create, params: { classroom: params }) }
    let(:params) do
      {
        title: title,
        description: description
      }
    end
    let(:title) { Faker::Lorem.word }
    let(:description) { Faker::DrWho.quote.first(300) }

    in_context :authenticated do
      it "returns a 201" do
        subject
        expect(response).to be_created
      end

      it "returns the new classroom" do
        subject
        expect(json_response[:id]).not_to be_blank
      end

      it "creates the classroom" do
        expect{ subject }.to change(Classroom, :count).by(1)
      end

      it "sets the creator to current_user" do
        subject
        expect(json_response[:creator_id]).to eq(test_user.id)
      end

      context "classroom is missing from params" do
        subject { post(:create, params: {}) }

        it "returns a 403" do
          subject
          expect(response).to be_forbidden
        end

        it "returns a readable error" do
          subject
          expect(json_response[:errors].first).to include("classroom")
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
    subject { patch(:update, params: { id: id, classroom: params }) }
    let(:params) do
      {
        title: title,
        description: description
      }
    end
    let!(:classroom) { create(:classroom, creator: creator) }
    let(:title) { Faker::Lorem.word }
    let(:description) { Faker::StarWars.quote.first(300) }
    let(:id) { classroom.id }
    let(:creator) { test_user }

    in_context :authenticated do
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

      it "returns the updated classroom" do
        subject
        expect(json_response[:title]).to eq title
        expect(json_response[:description]).to eq description
      end

      it "updates the classroom" do
        expect{ subject }.to change{ classroom.reload.title }.to(title).and(
          change{ classroom.reload.description }.to(description)
        )
      end

      in_context "inexistant classroom"

      context "classroom is missing from params" do
        subject { patch(:update, params: { id: id }) }

        it "returns a 403" do
          subject
          expect(response).to be_forbidden
        end

        it "returns a readable error" do
          subject
          expect(json_response[:errors].first).to include("classroom")
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
