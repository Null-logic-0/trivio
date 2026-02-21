class SessionsController < ApplicationController
	allow_unauthenticated_access only: %i[ new create ]
	rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to login_path, alert: "Try again later." }

	def new

	end

	def create
		if (user = User.authenticate_by_login(user_params[:login], user_params[:password]))
			start_new_session_for user
			redirect_to after_authentication_url, notice: "Logged in!"
		else
			flash.now[:alert] = "Invalid credentials"
			render :new, status: :unprocessable_entity
		end
	end

	def destroy
		terminate_session
		redirect_to login_path, status: :see_other, notice: "You have been logged out."
	end

	private

	def user_params
		params.permit(:login, :password)
	end
end
