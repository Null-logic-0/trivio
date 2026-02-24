class Trade < ApplicationRecord
	belongs_to :user
	belongs_to :stock

	validates :shares, numericality: { greater_than: 0 }

	Turbo::StreamsChannel.broadcast_update_to(
		"portfolio_chart_#{Current.user.username}",
		target: "portfolio-chart",
		partial: "dashboard/portfolio_chart",
		locals: { portfolio_history: Current.user.trades.group_by_day(:created_at).sum("shares * price") }
	)
end
