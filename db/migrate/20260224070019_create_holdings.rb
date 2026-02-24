class CreateHoldings < ActiveRecord::Migration[8.1]
  def change
    create_table :holdings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.integer :shares

      t.timestamps
    end
  end
end
