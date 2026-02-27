class AddBuyingPowerToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :buying_power, :decimal, default: 10_000
  end
end
