# frozen_string_literal: true

module DeviseHelper
  def test_user
    @test_user ||= create(:user)
  end

  def auth_me_please
    request.headers.merge! test_user.create_new_auth_token
  end
end

RSpec.define_context "authenticated" do
  it "fails without auth" do
    subject
    expect(response).to be_unauthorized
  end

  context "with a auth user" do
    before { auth_me_please }

    execute_tests
  end
end
