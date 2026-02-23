require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
	setup { @user = User.take }

	test "new" do
		get new_password_path
		assert_response :success
	end

	test "create" do
		post passwords_path, params: { email_address: @user.email_address }

		# Adjusted for Rails 7 enqueued mailer syntax
		assert_enqueued_email_with PasswordsMailer, :reset, args: [@user]

		assert_redirected_to login_path

		follow_redirect!
		assert_notice "Password reset instructions sent."
	end

	test "create for an unknown user renders new with alert" do
		post passwords_path, params: { email_address: "missing-user@example.com" }

		assert_enqueued_emails 0
		assert_response :unprocessable_entity
		assert_select "div", /Email address not found/
	end

	test "edit" do
		get edit_password_path(@user.password_reset_token)
		assert_response :success
	end

	test "edit with invalid password reset token redirects with alert" do
		get edit_password_path("invalid token")
		assert_redirected_to forgot_password_path

		follow_redirect!
		assert_notice "Password reset link is invalid or has expired."
	end

	test "update" do
		patch password_path(@user.password_reset_token),
		      params: { password: "newpassword", password_confirmation: "newpassword" }

		follow_redirect!
		assert_equal "Password has been reset.", flash[:notice]
	end

	test "update with non matching passwords shows errors" do
		token = @user.password_reset_token
		assert_no_changes -> { @user.reload.password_digest } do
			put password_path(token), params: { password: "no", password_confirmation: "match" }
			assert_response :unprocessable_entity
			assert_select "div", /Password confirmation doesn't match Password/
		end
	end

	private

	def assert_notice(text)
		assert_select "div", /#{text}/
	end
end