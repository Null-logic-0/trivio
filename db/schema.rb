# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_24_134139) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "holdings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "shares"
    t.bigint "stock_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["stock_id"], name: "index_holdings_on_stock_id"
    t.index ["user_id"], name: "index_holdings_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "stock_snapshots", force: :cascade do |t|
    t.datetime "captured_at"
    t.datetime "created_at", null: false
    t.decimal "price"
    t.bigint "stock_id", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_id"], name: "index_stock_snapshots_on_stock_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "current_price", precision: 15, scale: 2
    t.decimal "market_cap"
    t.string "name"
    t.string "symbol"
    t.datetime "updated_at", null: false
  end

  create_table "trades", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "price"
    t.integer "shares"
    t.bigint "stock_id", null: false
    t.string "trade_type"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["stock_id"], name: "index_trades_on_stock_id"
    t.index ["user_id"], name: "index_trades_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.decimal "buying_power", default: "10000.0"
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "watchlists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "stock_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["stock_id"], name: "index_watchlists_on_stock_id"
    t.index ["user_id"], name: "index_watchlists_on_user_id"
  end

  add_foreign_key "holdings", "stocks"
  add_foreign_key "holdings", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "stock_snapshots", "stocks"
  add_foreign_key "trades", "stocks"
  add_foreign_key "trades", "users"
  add_foreign_key "watchlists", "stocks"
  add_foreign_key "watchlists", "users"
end
