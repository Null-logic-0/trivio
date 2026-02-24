class Holding < ApplicationRecord
	belongs_to :user
	belongs_to :stock

	def self.create_or_update!(user:, stock:, shares:)
		holding = find_or_initialize_by(user: user, stock: stock)
		holding.shares = (holding.shares || 0) + shares
		holding.save!
	end
end
