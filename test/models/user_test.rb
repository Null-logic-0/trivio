require "test_helper"

class UserTest < ActiveSupport::TestCase
	test "downcases and strips email_address" do
		user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
		assert_equal("downcased@example.com", user.email_address)
	end

	test "capitalizes first_name address" do
		user = User.new(first_name: " john")
		assert_equal("John", user.first_name)
	end

	test "capitalizes last_name address" do
		user = User.new(last_name: "doe")
		assert_equal("Doe", user.last_name)
	end

	test "downcase username" do
		user = User.new(username: "Johndoe")
		assert_equal("johndoe", user.username)
	end
end
