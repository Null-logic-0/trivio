class StocksController < ApplicationController
	def index
		@stocks = Stock.all.order(:symbol)
		UpdateStockPricesJob.perform_later

		respond_to do |format|
			format.html
			format.json { render json: @stocks.to_json(only: [:id, :symbol, :name, :current_price]) }
		end
	end

	def show
		@stock = Stock.find(params[:id])
		@stock_data = StockDataService.new(@stock.symbol)
		@quote = @stock_data.quote
		@profile = @stock_data.company_profile

	end

	def history
		stock = Stock.find(params[:id])
		service = StockDataService.new(stock.symbol)

		price = service.current_price

		render json: [[Time.current.strftime("%H:%M:%S"), price]]
	end
end
