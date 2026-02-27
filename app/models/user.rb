class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :holdings, dependent: :destroy
  has_many :trades, dependent: :destroy

  has_many :watchlist_items, class_name: "Watchlist", dependent: :destroy
  has_many :watchlist, through: :watchlist_items, source: :stock

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  normalizes :first_name, with: ->(e) { e.strip.capitalize }
  normalizes :last_name, with: ->(e) { e.strip.capitalize }
  normalizes :username, with: ->(e) { e.strip.downcase }

  validates :email_address, :username, presence: true, uniqueness: true
  validates :first_name, :last_name, :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }

  def self.authenticate_by_login(login, password)
    user = where("lower(email_address) = ? OR lower(username) = ?", login, login).first
    user if user&.authenticate(password)
  end
end
