require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should logout" do
    delete :destroy
    assert_redirected_to login_url
  end
end
