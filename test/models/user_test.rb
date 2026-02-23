require "test_helper"

class UserTest < ActiveSupport::TestCase
	setup do
		@user = User.new(
			first_name: " john ",
			last_name: " doe ",
			email_address: " TEST@Example.com ",
			username: " USER123 ",
			password: "password",
			password_confirmation: "password"
		)
	end

	test "should save valid user" do
		assert @user.save
	end

	test "should normalize attributes before save" do
		@user.save
		assert_equal "John", @user.first_name
		assert_equal "Doe", @user.last_name
		assert_equal "test@example.com", @user.email_address
		assert_equal "user123", @user.username
	end

	test "should require presence of mandatory fields" do
		@user.first_name = ""
		@user.last_name = ""
		@user.email_address = ""
		@user.username = ""
		@user.password = nil

		assert_not @user.valid?
		assert_includes @user.errors[:first_name], "can't be blank"
		assert_includes @user.errors[:last_name], "can't be blank"
		assert_includes @user.errors[:email_address], "can't be blank"
		assert_includes @user.errors[:username], "can't be blank"
		assert_includes @user.errors[:password_digest], "can't be blank"
	end

	test "should enforce uniqueness of email_address and username" do
		@user.save
		duplicate = @user.dup
		duplicate.password = "password"
		duplicate.password_confirmation = "password"
		assert_not duplicate.valid?
		assert_includes duplicate.errors[:email_address], "has already been taken"
		assert_includes duplicate.errors[:username], "has already been taken"
	end

	test "should enforce minimum password length" do
		@user.password = @user.password_confirmation = "123"
		assert_not @user.valid?
		assert_includes @user.errors[:password], "is too short (minimum is 6 characters)"
	end

	test "authenticate_by_login should return user for correct credentials" do
		@user.save
		assert_equal @user, User.authenticate_by_login("test@example.com", "password")
		assert_equal @user, User.authenticate_by_login("user123", "password")
	end

	test "authenticate_by_login should return nil for wrong credentials" do
		@user.save
		assert_nil User.authenticate_by_login("wrong@example.com", "password")
		assert_nil User.authenticate_by_login("test@example.com", "wrongpass")
	end
end