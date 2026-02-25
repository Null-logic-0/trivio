Rails.application.routes.draw do

	get "up" => "rails/health#show", as: :rails_health_check

	root "dashboard#index"
	get "dashboard/portfolio_history", to: "dashboard#portfolio_history_json", as: :portfolio_history
	get "dashboard/holdings", to: "dashboard#holdings_json", as: :holdings

	# Authentication
	get "/login", to: "sessions#new", as: :login
	post "/login", to: "sessions#create"
	delete "/logout", to: "sessions#destroy", as: :logout

	get "/signup", to: "register_users#new", as: :signup
	post "/signup", to: "register_users#create"

	# Passwords
	get "/forgot-password", to: "passwords#new", as: :forgot_password
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

	# Market news
	get "/news", to: "market_news#index", as: :news

end
