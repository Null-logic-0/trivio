require "test_helper"

class MarketNewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as(@user)
  end

  test "should get index and assign current user" do
    get news_path

    assert_response :success
  end
end
