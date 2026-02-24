class TradesController < ApplicationController
	def create
		stock = Stock.find_or_create_by(symbol: params[:symbol])
		shares = params[:shares].to_i
		price = StockDataService.new(stock.symbol).quote['c']

		if Current.user.buying_power >= shares * price
			Trade.create!(user: Current.user,
			              stock: stock,
			              shares: shares,
			              trade_type: "buy",
			              price: price)
			Holding.create_or_update!(user: Current.user,
			                          stock: stock,
			                          shares: shares)
			Current.user.update!(buying_power: Current.user.buying_power - shares * price)
			flash.now[:notice] = "Bought #{shares} shares of #{stock.symbol}"
		else
			flash.now[:alert] = "Not enough buying power!"
		end
		respond_to do |format|
			format.turbo_stream { render turbo_stream: turbo_stream.append("flash_messages", partial: "layouts/flash") }
			format.html { redirect_to root_path }
		end
	end

end
