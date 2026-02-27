class WatchlistsController < ApplicationController
  def create
    stock = Stock.find_by(symbol: params[:symbol])
    Current.user.watchlist_items.find_or_create_by(stock: stock)

    redirect_to root_path, notice: "#{stock&.symbol} added to watchlist."
  end

  def destroy
    watchlist_item = Current.user.watchlist_items.find(params[:id])
    @watchlist = Current.user.watchlist.includes(:watchlist_items)

    if watchlist_item
      stock = watchlist_item.stock
      watchlist_item.destroy
      flash[:notice] = "Stock removed from watchlist."

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove("watchlist-item-#{watchlist_item.id}"),

            turbo_stream.replace("watchlist_count", @watchlist.count),

            turbo_stream.update("watchlist-#{stock.id}", partial: "watchlists/button", locals: { stock: stock }),

            turbo_stream.append("flash", partial: "shared/flash"),
            turbo_stream.replace(
              "watchlist_empty",
              partial: "shared/empty_state",
              locals: { message: "No stocks watched yet" }
            )
          ].compact
        end
        format.html { redirect_to root_path }
      end
    else
      flash[:alert] = "Failed to delete watchlist item!"
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append("flash", partial: "shared/flash")
        end
        format.html { redirect_to root_path }
      end
    end
  end
end
