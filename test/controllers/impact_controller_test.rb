require "test_helper"

class ImpactControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get impact_index_url
    assert_response :success
  end
end
