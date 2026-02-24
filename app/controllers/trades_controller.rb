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
			redirect_to root_path, notice: "Bought #{shares} shares of #{stock.symbol}"
		else
			redirect_to stocks_path, alert: "Not enough buying power!"
		end

	end

	def sell
		stock = Stock.find_by(symbol: params[:symbol])
		shares_to_sell = params[:shares].to_i

		unless stock
			flash.now[:alert] = "Stock not found."
			return respond(format: :html)
		end

		holding = Current.user.holdings.find_by(stock: stock)

		if holding.nil? || holding.shares < shares_to_sell
			flash.now[:alert] = "You don't have enough shares to sell."
			return respond(format: :html)
		end

		price = StockDataService.new(stock.symbol).quote['c']

		Trade.create!(
			user: Current.user,
			stock: stock,
			shares: shares_to_sell,
			trade_type: "sell",
			price: price
		)

		if holding.shares == shares_to_sell
			holding.destroy
		else
			holding.update!(shares: holding.shares - shares_to_sell)
		end

		Current.user.update!(buying_power: Current.user.buying_power + shares_to_sell * price)

		flash.now[:notice] = "Sold #{shares_to_sell} shares of #{stock.symbol}"
		respond_to do |f|
			f.turbo_stream { render turbo_stream: turbo_stream.append("flash_messages", partial: "layouts/flash") }
			f.html { redirect_to root_path }
		end
	end

end
