Rails.application.routes.draw do

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

	# Trading
	resources :trades, only: [:create] do
		post :sell, on: :collection
	end

	# Watchlist
	resources :watchlists, only: [:create, :destroy]

	# Stocks
	resources :stocks, only: [:index, :show] do
		get :history, on: :member, defaults: { format: :json }
	end

	root "dashboard#index"
	get "dashboard/portfolio_history", to: "dashboard#portfolio_history_json", as: :portfolio_history
	get "dashboard/top_movers", to: "dashboard#top_movers_json", as: :top_movers
	get "dashboard/holdings", to: "dashboard#holdings_json", as: :holdings
end
