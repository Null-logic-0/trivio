class Watchlist < ApplicationRecord
	belongs_to :user
	belongs_to :stock

	validates :user_id, uniqueness: { scope: :stock_id }
end
