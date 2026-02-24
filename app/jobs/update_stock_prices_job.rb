class UpdateStockPricesJob < ApplicationJob
	include Sidekiq::Job
	queue_as :stock_updates

	def perform
		Stock.find_each do |stock|
			data = StockDataService.new(stock.symbol).quote
			next unless data['c']
			stock.update!(current_price: data['c'])
		rescue => e
			Rails.logger.error "Failed to update #{stock.symbol}: #{e.message}"
		end
	end
end
