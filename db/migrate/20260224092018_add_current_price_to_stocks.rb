class AddCurrentPriceToStocks < ActiveRecord::Migration[8.1]
	def change
		add_column :stocks, :current_price, :decimal, precision: 15, scale: 2
	end
end
