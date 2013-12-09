require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get index for admin" do
    sign_in users(:admin)
    get :index
    assert_response :success    
  end

  test "should not get index for plain user" do
    sign_in users(:user)
    get :index
    assert_response :redirect
  end
end
