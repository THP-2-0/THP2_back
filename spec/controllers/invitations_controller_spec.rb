# frozen_string_literal: true

describe InvitationsController do
  define_context "inexistant invitation" do
    context "when the invitation doesn't exist" do
      let(:invitation_id) { Faker::Lorem.word }

      it 'returns a 404' do
        subject
        expect(response).to be_not_found
      end
    end
  end

  define_context "need to be" do |type|
    it "fails if the user isn't the #{type}" do
      subject
      expect(response).to be_unauthorized
    end

    context "when it is the #{type}" do
      let(type) { test_user }

      execute_tests
    end
  end

  let!(:classroom) { create(:classroom) }
  let(:lesson) { create(:lesson, classroom: classroom, teacher: teacher) }
  let(:teacher) { create(:user) }
  let(:student) { create(:user) }

  describe '#index' do
    subject { get :index, params: { classroom_id: classroom.id, lesson_id: lesson.id } }

    in_context(:authenticated) do
      let!(:invitations) { create_list(:invitation, 5, lesson: lesson) }
      let(:create_other_invitation) { create(:invitation) }

      before { create_other_invitation }

      it 'returns all the invitations' do
        subject
        expect(json_response[:invitations].size).to eq(5)
        expect(json_response[:invitations].first[:id]).to be_in(invitations.map(&:id))
      end

      it 'returns a 200' do
        subject
        expect(response).to be_ok
      end
    end
  end

  describe '#show' do
    subject { get :show, params: { lesson_id: lesson.id, classroom_id: classroom.id, id: invitation_id } }

    let!(:invitation) { create(:invitation, lesson: lesson) }
    let(:invitation_id) { invitation.id }

    in_context(:authenticated) do
      it 'returns a 200' do
        subject
        expect(response).to be_ok
      end

      it 'returns the right fields' do
        subject
        %i[id accepted student_id teacher_id].each do |field|
          expect(json_response[:invitation][field]).to eq(invitation.public_send(field))
        end
      end

      in_context "inexistant invitation"
    end
  end

  describe '#create' do
    subject { post :create, params: params.merge(classroom_id: classroom.id, lesson_id: lesson.id) }

    let(:params) { { invitation: { student_id: student_id } } }
    let(:student) { create(:user) }
    let(:student_id) { student.id }

    in_context(:authenticated) do
      in_context("need to be", :teacher) do
        context "when the student doesn't exist" do
          let(:student_id) { Faker::Lorem.word }

          it "fails with a 404" do
            subject
            expect(response).to be_not_found
          end
        end

        it "succeed with a 201" do
          subject
          expect(response).to be_created
        end

        it "returns the newly created invitation" do
          subject
          expect(json_response[:invitation][:student_id]).to eq(student.id)
        end
        it "creates the invitation" do
          expect{ subject }.to change(Invitation, :count).by(1)
        end
      end
    end
  end

  describe '#destroy' do
    subject { delete :destroy, params: { classroom_id: classroom.id, lesson_id: lesson.id, id: invitation_id } }

    let!(:invitation) { create(:invitation, lesson: lesson, teacher: teacher) }
    let(:invitation_id) { invitation.id }

    in_context :authenticated do
      in_context "inexistant invitation"

      in_context "need to be", :teacher do
        it "removes the invitation" do
          expect{ subject }.to change(Invitation, :count).by(-1)
        end

        it "answers with head 204" do
          subject
          expect(response).to be_no_content
        end
      end
    end
  end

  describe "#update" do
    subject { patch :update, params: { classroom_id: classroom.id, lesson_id: lesson.id, id: invitation_id }.merge(invitation: params) }

    let!(:invitation) { create(:invitation, lesson: lesson, student: student) }
    let(:invitation_id) { invitation.id }
    let(:params) { { accepted: true } }

    in_context :authenticated do
      in_context "inexistant invitation"
      in_context "need to be", :student do
        context "when accepted isn't present" do
          let(:params) { {} }

          it "fails with forbidden" do
            subject
            expect(response).to be_forbidden
          end
        end

        context "when accepted is not true" do
          let(:params) { { accepted: false } }

          it "fails with forbidden" do
            subject
            expect(response).to be_forbidden
          end
        end

        it "succeed with a 200" do
          subject
          expect(response).to be_ok
        end

        it "updates the invitation" do
          expect{ subject }.to change{ invitation.reload.accepted? }.from(false).to(true)
        end
      end
    end
  end
end
