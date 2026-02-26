class TradesController < ApplicationController
	def create
		stock = Stock.find_or_create_by(symbol: params[:symbol])
		shares = params[:shares].to_i
		price = StockDataService.new(stock.symbol).quote['c'].to_d

		total_cost = shares * price

		if Current.user.buying_power >= total_cost
			Trade.create!(
				user: Current.user,
				stock: stock,
				shares: shares,
				trade_type: "buy",
				price: price
			)

			Holding.create_or_update!(
				user: Current.user,
				stock: stock,
				shares: shares
			)

			Current.user.update!(
				buying_power: Current.user.buying_power - total_cost)

			redirect_to root_path, notice: "Bought #{shares} shares of #{stock.symbol}"
		else
			redirect_to stocks_path, alert: "Not enough buying power!"
		end

	end

	def sell
		stock = Stock.find_by(symbol: params[:symbol])
		shares_to_sell = params[:shares].to_i

		unless stock
			message = "Stock not found."
			respond_to do |format|
				format.turbo_stream do
					flash.now[:alert] = message
					render turbo_stream: turbo_stream.append(
						"flash",
						partial: "shared/flash"
					)
				end

				format.html { redirect_to root_path, alert: message }
			end
			return
		end

		holding = Current.user.holdings.find_by(stock: stock)

		if holding.nil? || holding.shares < shares_to_sell
			message = "You don't have enough shares to sell."
			respond_to do |format|
				format.turbo_stream do
					flash.now[:alert] = message
					render turbo_stream: turbo_stream.append(
						"flash",
						partial: "shared/flash"
					)
				end
				format.html { redirect_to root_path, alert: message }
			end
			return
		end

		price = StockDataService.new(stock.symbol).quote['c'].to_d
		total_value = shares_to_sell * price

		Trade.create!(
			user: Current.user,
			stock: stock,
			shares: shares_to_sell,
			trade_type: "sell",
			price: price
		)

		if holding.shares == shares_to_sell
			holding.destroy
			turbo_stream_action = turbo_stream.remove("holding_#{holding.id}")
			turbo_empty = turbo_stream.replace(
				"portfolio_empty",
				partial: "shared/empty_state",
				locals: { message: "No holdings yet" }
			)
		else
			holding.update!(shares: holding.shares - shares_to_sell)
			turbo_stream_action = turbo_stream.replace(
				"holding_#{holding.id}",
				partial: "dashboard/holding_row",
				locals: { holding: holding }
			)
			turbo_empty = turbo_stream.replace("portfolio_empty", "")

		end

		Current.user.update!(buying_power: Current.user.buying_power + total_value)
		flash.now[:notice] = "Sold #{shares_to_sell} shares of #{stock.symbol}"

		@holdings = Current.user.holdings.includes(:stock)

		respond_to do |format|
			format.turbo_stream do
				render turbo_stream: [
					turbo_stream_action,
					turbo_stream.replace("holdings_count", @holdings.count),
					turbo_stream.replace("buying_power", partial: "shared/buying_power"),
					turbo_stream.append("flash", partial: "shared/flash"),
					turbo_empty
				].compact
			end
			format.html { redirect_to root_path }
		end
	end

end
