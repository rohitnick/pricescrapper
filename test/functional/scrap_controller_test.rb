require 'test_helper'

class ScrapControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
