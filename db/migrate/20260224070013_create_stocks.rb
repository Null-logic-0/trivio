class CreateStocks < ActiveRecord::Migration[8.1]
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.string :name
      t.decimal :market_cap

      t.timestamps
    end
  end
end
