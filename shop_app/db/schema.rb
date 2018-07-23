# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180723075720) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_link"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.integer "parent_id", default: 0
    t.integer "sort_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 1
    t.index ["name"], name: "index_categories_on_name"
  end

  create_table "comment_products", force: :cascade do |t|
    t.integer "user_id"
    t.integer "product_id"
    t.text "content"
    t.datetime "date_created"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "article_id"
    t.text "content"
    t.datetime "day_created"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id"
    t.integer "status"
  end

  create_table "customers", force: :cascade do |t|
    t.string "first_name"
    t.string "email"
    t.string "phone"
    t.string "address_deliver"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.string "last_name"
    t.string "company"
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "product_id"
    t.integer "status", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer "product_id"
    t.integer "transaction_id"
    t.float "total_payment"
    t.integer "status"
    t.text "data"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "price"
    t.string "size"
    t.string "type"
  end

  create_table "payments", force: :cascade do |t|
    t.datetime "expires_at"
    t.datetime "purchased_at"
    t.integer "quantity"
    t.string "status"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "transaction_id"
    t.integer "amount", default: 1
    t.string "token"
    t.boolean "canceled", default: false
    t.string "payer_id"
  end

  create_table "product_options", force: :cascade do |t|
    t.integer "product_id"
    t.integer "size_id"
    t.integer "type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "price"
  end

  create_table "products", force: :cascade do |t|
    t.integer "category_id"
    t.string "name"
    t.text "description"
    t.integer "discount"
    t.string "image_link"
    t.integer "like", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sizes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "status", default: 0
    t.integer "customer_id"
    t.float "amount"
    t.string "comment"
    t.datetime "created"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "delivery_time"
    t.string "receiver"
    t.integer "phone_rec"
    t.string "address_deliver_rec"
    t.text "notification_params"
    t.string "status_paypal"
    t.string "checkout_id"
    t.datetime "purchased_at"
  end

  create_table "types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "password_confirmation"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "address"
    t.string "remember_digest"
    t.string "reset_digest"
    t.datetime "last_login"
    t.datetime "reset_sent_at"
    t.string "activation_digest"
    t.datetime "activated_at"
    t.boolean "activated", default: false
    t.integer "role_id", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar"
    t.string "company"
    t.string "address_deliver"
    t.string "api_key"
    t.datetime "activation_sent_at"
  end

end
