# frozen_string_literal: true

module DeviseHelper
  def test_user
    @test_user ||= create(:user)
  end

  def auth_me_please
    request.headers.merge! test_user.create_new_auth_token
  end
end
