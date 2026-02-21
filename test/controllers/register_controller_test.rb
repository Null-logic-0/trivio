require "test_helper"

class RegisterControllerTest < ActionDispatch::IntegrationTest

	test "should get new" do
		get signup_path
		assert_response :success
	end

	test "should create new user" do
		post signup_path, params: {
			user: {
				first_name: "john",
				last_name: "doe",
				username: "john_doe_19",
				email_address: "doe@example.com",
				password: "password",

			}
		}
		assert_redirected_to root_path
	end
end
