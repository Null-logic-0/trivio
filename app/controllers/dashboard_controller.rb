class DashboardController < ApplicationController
  def index
    @user = Current.user
  end

  def content
    @user = Current.user
    @holdings = @user.holdings.includes(:stock)
    @range = params[:range] || "1d"

    days = case @range
    when "1d" then 1
    when "1w" then 7
    when "1m" then 30
    when "3m" then 90
    when "1y" then 365
    when "all" then nil
    else
             1
    end

    trades = @user.trades
    trades = trades.where("created_at >= ?", days.days.ago) if days

    @portfolio_history = trades.group_by_day(:created_at)
                               .sum("shares * price").transform_keys(&:to_s)

    values = @portfolio_history.values
    @portfolio_value = values.sum
    @daily_change = values.last.to_f - values[-2].to_f
    @daily_change_percent = values[-2].to_f > 0 ? ((@daily_change / values[-2].to_f) * 100).round(2) : 0.0

    render(partial: "dashboard/dashboard_content")
  end

  def portfolio_history_json
    data = Current.user.trades.group_by_day(:created_at).sum("shares * price").transform_keys(&:to_s)
    render json: data
  end

  def holdings_json
    data = Current.user.holdings.includes(:stock).map do |h|
      {
        symbol: h.stock.symbol,
        shares: h.shares
      }
    end
    render json: data
  end
end
