require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
	setup do
		@user = users(:one)
		sign_in_as(@user)
	end
	test "should get index" do
		get root_path
		assert_response :success
	end
end
