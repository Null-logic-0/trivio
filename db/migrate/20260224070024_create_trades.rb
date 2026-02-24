class CreateTrades < ActiveRecord::Migration[8.1]
  def change
    create_table :trades do |t|
      t.references :user, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.integer :shares
      t.string :trade_type
      t.decimal :price

      t.timestamps
    end
  end
end
