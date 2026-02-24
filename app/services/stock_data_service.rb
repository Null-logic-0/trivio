class StockDataService
	include HTTParty
	base_uri "https://finnhub.io/api/v1"

	def initialize(symbol)
		@symbol = symbol
		@api_key = Rails.application.credentials.dig(:finnhub, :api_key)
	end

	def quote
		self.class.get('/quote', query: { symbol: @symbol, token: @api_key }).parsed_response
	end

	def company_profile
		self.class.get("/stock/profile2", query: { symbol: @symbol, token: @api_key }).parsed_response
	end

	def top_movers
		stocks = Stock.limit(50)

		stocks.map do |stock|
			data = self.class.get("/quote", query: {
				symbol: stock.symbol,
				token: @api_key
			}).parsed_response

			next unless data["c"] && data["dp"]

			{
				symbol: stock.symbol,
				price: data["c"],
				change: data["d"],
				percent_change: data["dp"]
			}
		end
		      .compact
		      .sort_by { |s| -s[:percent_change].to_f }
		      .first(10)
	end

	def current_price
		response = self.class.get("/quote", query: {
			symbol: @symbol,
			token: @api_key
		}).parsed_response

		response["c"] # current price
	end
end