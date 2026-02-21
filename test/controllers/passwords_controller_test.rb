require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
	setup { @user = User.take }

	test "new" do
		get forgot_password_path
		assert_response :success
	end

	test "create" do
		post passwords_path, params: { email_address: @user.email_address }
		assert_enqueued_email_with PasswordsMailer, :reset, args: [@user]
		assert_redirected_to login_path

		follow_redirect!
		assert_notice "reset instructions sent"
	end

	test "create for an unknown user redirects but sends no mail" do
		post passwords_path, params: { email_address: "missing-user@example.com" }
		assert_enqueued_emails 0
		assert_response :unprocessable_entity

		assert_notice "Email address not found"
	end

	test "edit" do
		get edit_password_path(@user.password_reset_token)
		assert_response :success
	end

	test "edit with invalid password reset token" do
		get edit_password_path("invalid token")

		assert_redirected_to forgot_password_path
		follow_redirect!

		assert_match "reset link is invalid", response.body
	end

	test "update changes password successfully" do

		put password_path(@user.password_reset_token),
		    params: { password: "new_password", password_confirmation: "new_password" }

		@user.reload

		assert_redirected_to login_path
		follow_redirect!
		assert_notice "Password has been reset."
	end

	private

	def assert_notice(text)
		assert_select "div", /#{text}/
	end
end
