require 'test_helper'

class StatControllerTest < ActionController::TestCase
  test "should get time" do
    get :time
    assert_response :success
  end

end
