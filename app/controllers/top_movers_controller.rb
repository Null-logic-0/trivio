class TopMoversController < ApplicationController

	def show
		@top_movers = Rails.cache.fetch("top_movers", expires_in: 5.minutes) do
			StockDataService.new(nil).top_movers
		end
	end
end
