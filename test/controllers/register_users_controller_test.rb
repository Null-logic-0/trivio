require "test_helper"

class RegisterUsersControllerTest < ActionDispatch::IntegrationTest

	test "should render register page" do
		get signup_path
		assert_response :success
	end

	test "should register new user successfully" do
		post signup_path, params: {
			user: {
				first_name: "John",
				last_name: "Doe",
				email_address: "john#{SecureRandom.hex(4)}@example.com",
				username: "user#{SecureRandom.hex(4)}",
				password: "password",
				password_confirmation: "password"
			}
		}

		assert_redirected_to root_url
		follow_redirect!
		assert_equal "Registered!", flash[:notice]
	end

	test "should render new on invalid data" do
		post signup_path, params: {
			user: {
				first_name: "",
				last_name: "",
				email_address: "invalid-email",
				username: "",
				password: "short",
				password_confirmation: "mismatch"
			}
		}

		assert_response :unprocessable_entity
		assert_select "div", /can't be blank|is too short|doesn't match/
	end

end
