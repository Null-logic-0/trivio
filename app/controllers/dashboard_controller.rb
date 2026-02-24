class DashboardController < ApplicationController
	def index
		@user = Current.user
		@holdings = @user.holdings.includes(:stock)
		@top_movers = StockDataService.new(nil).top_movers
		@portfolio_history = @user.trades.group_by_day(:created_at)
		                          .sum("shares * price").transform_keys(&:to_s)
	end

	def portfolio_history_json
		data = Current.user.trades.group_by_day(:created_at).sum("shares * price").transform_keys(&:to_s)
		render json: data
	end

	def top_movers_json
		data = StockDataService.new(nil).top_movers
		render json: data
	end

	def holdings_json
		data = Current.user.holdings.includes(:stock).map do |h|
			{
				symbol: h.stock.symbol,
				shares: h.shares
			}
		end
		render json: data
	end
end
