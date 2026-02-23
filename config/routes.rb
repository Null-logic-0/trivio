Rails.application.routes.draw do
	# Defines the root path route ("/")
	root "dashboard#index"

	get "up" => "rails/health#show", as: :rails_health_check

	# Authentication
	get "/login" => "sessions#new", as: :login
	post "/login" => "sessions#create"
	delete "/logout" => "sessions#destroy", as: :logout

	get "/signup" => "register_users#new", as: :signup
	post "/signup" => "register_users#create"

	# Passwords
	get "/forgot-password" => "passwords#new", as: :forgot_password
	resources :passwords, param: :token, only: [:new, :create, :edit, :update]

end
