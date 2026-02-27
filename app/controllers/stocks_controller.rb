class StocksController < ApplicationController
	def index
		@pagy, @stocks = pagy(Stock.all.order(:symbol), limit: 10)
		UpdateStockPricesJob.perform_later

		respond_to do |format|
			format.html
			format.turbo_stream { render partial: "stocks/stocks_table" }
			format.json { render json: @stocks.to_json(only: [:id, :symbol, :name, :current_price]) }
		end
	end

	def table_partial
		@stocks = Stock.all.order(:symbol)
		render partial: "stocks/stocks_table"
	end

	def show
		@stock = Stock.find(params[:id])
	end

	def stock_data
		@stock = Stock.find(params[:id])

		service = StockDataService.new(@stock.symbol)

		@quote = Rails.cache.fetch("quote-#{@stock.symbol}", expires_in: 1.minute) do
			service.quote
		end

		@profile = Rails.cache.fetch("profile-#{@stock.symbol}", expires_in: 5.minutes) do
			service.company_profile
		end

		render partial: "stocks/stock_data"
	end

	def history
		stock = Stock.find(params[:id])
		service = StockDataService.new(stock.symbol)

		price = service.current_price

		render json: [[Time.current.strftime("%H:%M:%S"), price]]
	end

end
