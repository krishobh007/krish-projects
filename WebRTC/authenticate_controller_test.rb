require 'test_helper'

class AuthenticateControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get success" do
    get :success
    assert_response :success
  end

  test "should get pre_login" do
    get :pre_login
    assert_response :success
  end

end
