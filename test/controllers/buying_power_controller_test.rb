require "test_helper"

class BuyingPowerControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as(@user)
  end

  test "should reset buying_power via html" do
    post buying_power_reset_path, headers: { "Accept" => "text/html" }
    assert_equal 10_000, @user.buying_power
    assert_redirected_to root_path
  end

  test "should reset buying_power via turbo_stream" do
    post buying_power_reset_path, headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_equal 10_000, @user.buying_power

    assert_match "buying_power", @response.body
    assert_match "flash", @response.body
  end
end
