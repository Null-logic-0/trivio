class Stock < ApplicationRecord
  has_many :holdings, dependent: :destroy
  has_many :trades, dependent: :destroy

  has_many :watchlist_items, class_name: "Watchlist", dependent: :destroy
  has_many :watchers, through: :watchlist_items, source: :user
end
