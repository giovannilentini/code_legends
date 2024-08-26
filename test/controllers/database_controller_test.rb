require "test_helper"

class DatabaseControllerTest < ActionDispatch::IntegrationTest
  test "should get info" do
    get database_info_url
    assert_response :success
  end
end
