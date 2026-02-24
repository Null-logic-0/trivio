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
		symbols = %w[AAPL TSLA AMZN NVDA MSFT]

		symbols.map do |symbol|
			data = self.class.get('/quote', query: { symbol: symbol, token: @api_key }).parsed_response

			next unless data["c"]

			{
				symbol: symbol,
				price: data["c"],
				change: data["d"],
				percent_change: data["dp"]
			}
		end.compact.sort_by { |stock| -stock[:percent_change].to_f }
	end

	def current_price
		response = self.class.get("/quote", query: {
			symbol: @symbol,
			token: @api_key
		}).parsed_response

		response["c"] # current price
	end
end