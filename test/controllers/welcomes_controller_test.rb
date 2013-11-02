require 'test_helper'

class WelcomesControllerTest < ActionController::TestCase
  setup do
    @welcome = welcomes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
  end
end
