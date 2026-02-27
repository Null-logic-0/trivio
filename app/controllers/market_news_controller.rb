class MarketNewsController < ApplicationController
  def index
    news_items = StockDataService.new(nil).news
    sorted_news = news_items.sort_by! { |item| -item["datetime"].to_i }

    @pagy, @news = pagy(sorted_news, limit: 10)
  end
end
