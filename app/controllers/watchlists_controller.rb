class WatchlistsController < ApplicationController
	def create
		stock = Stock.find_by(symbol: params[:symbol])
		Current.user.watchlist_items.find_or_create_by(stock: stock)

		redirect_to root_path, notice: "#{stock&.symbol} added to watchlist."
	end

	def destroy
		watchlist_item = Current.user.watchlist_items.find(params[:id])

		if watchlist_item
			watchlist_item.destroy
			flash[:notice] = "Stock removed from watchlist."
		else
			flash[:alert] = "Failed to delete watchlist item!"
		end

		redirect_to root_path
	end
end
