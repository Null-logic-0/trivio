class Trade < ApplicationRecord
	belongs_to :user
	belongs_to :stock

	validates :shares, numericality: { greater_than: 0 }

	after_create_commit :broadcast_portfolio_chart, if: -> { Current.user.present? }

	private

	def broadcast_portfolio_chart
		Turbo::StreamsChannel.broadcast_update_to(
			"portfolio_chart_#{Current.user.username}",
			target: "portfolio-chart",
			partial: "dashboard/portfolio_chart",
			locals: { portfolio_history: Current.user.trades.group_by_day(:created_at).sum("shares * price") }
		)
	end
end
