# frozen_string_literal: true

describe InvitationsController do
  let!(:classroom) { create(:classroom) }
  let(:lesson) { create(:lesson, classroom: classroom, teacher: teacher) }
  let(:teacher) { create(:user) }

  describe '#index' do
    subject { get :index, params: { classroom_id: classroom.id, lesson_id: lesson.id } }

    it 'fails wit a 401' do
      subject
      expect(response).to be_unauthorized
    end

    context 'with a logged the user' do
      before do
        auth_me_please
      end

      let!(:invitations) { create_list(:invitation, 5, lesson: lesson) }
      let!(:other_invitation) { create(:invitation) }

      it 'returns all the invitations' do
        subject
        expect(json_response.size).to eq(5)
        expect(json_response.first[:id]).to be_in(invitations.map(&:id))
      end

      it 'returns a 200' do
        subject
        expect(response).to be_ok
      end
    end
  end

  describe '#show' do
    subject { get :show, params: { lesson_id: lesson.id, classroom_id: classroom.id, id: id } }
    let!(:invitation) { create(:invitation, lesson: lesson) }
    let(:id) { invitation.id }

    it 'fails without auth' do
      subject
      expect(response).to be_unauthorized
    end

    context 'with auth user' do
      before { auth_me_please }

      it 'returns a 200' do
        subject
        expect(response).to be_ok
      end

      it 'returns the right fields' do
        subject
        %i[id accepted student_id teacher_id].each do |field|
          expect(json_response[field]).to eq(invitation.public_send(field))
        end
      end

      context "if the id doesn't exist" do
        let(:id) { Faker::Lorem.word }

        it 'returns a 404' do
          subject
          expect(response).to be_not_found
        end
      end
    end
  end

  describe '#create' do
    subject { post :create, params: params.merge(classroom_id: classroom.id, lesson_id: lesson.id) }
    let(:params) { { invitation: { student_id: student_id } } }
    let(:student) { create(:user) }
    let(:student_id) { student.id }

    it "fails without auth" do
      subject
      expect(response).to be_unauthorized
    end

    context "with a auth user" do
      before { auth_me_please }

      it "fails if the user isn't the teacher" do
        subject
        expect(response).to be_unauthorized
      end

      context 'that is the teacher' do
        let(:teacher) { test_user }

        context "if the student doesn't exist" do
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
          expect(json_response[:student_id]).to eq(student.id)
        end
        it "creates the invitation" do
          expect{ subject }.to change(Invitation, :count).by(1)
        end
      end
    end
  end

  describe '#destroy' do
    subject { delete :destroy, params: { classroom_id: classroom.id, lesson_id: lesson.id, id: invitation.id } }
  end
end
