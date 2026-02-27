require "test_helper"

class StocksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stock = stocks(:one)
    @user = users(:one)
    sign_in_as(@user)
  end
  test "should get index" do
    get stocks_path
    assert_response :success
  end

  test "should get show" do
    get stock_path(@stock)
    assert_response :success
  end
end
