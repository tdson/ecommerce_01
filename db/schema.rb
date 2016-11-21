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

ActiveRecord::Schema.define(version: 20161119113415) do

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "left_node"
    t.integer  "right_node"
    t.integer  "depth"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "order_products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.integer  "current_price"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "deleted_at"
    t.index ["order_id"], name: "index_order_products_on_order_id", using: :btree
    t.index ["product_id"], name: "index_order_products_on_product_id", using: :btree
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "status",           default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "full_name"
    t.string   "shipping_address"
    t.string   "phone"
    t.datetime "deleted_at"
    t.index ["user_id"], name: "index_orders_on_user_id", using: :btree
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "category_id"
    t.string   "name"
    t.string   "description"
    t.string   "image"
    t.integer  "price"
    t.integer  "quantity"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["category_id"], name: "index_products_on_category_id", using: :btree
    t.index ["name"], name: "index_products_on_name", using: :btree
  end

  create_table "ratings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "product_id"
    t.integer  "user_id"
    t.integer  "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_ratings_on_product_id", using: :btree
    t.index ["user_id"], name: "index_ratings_on_user_id", using: :btree
  end

  create_table "suggestions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "content"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "is_read",    default: false
    t.index ["user_id"], name: "index_suggestions_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.integer  "role",                   default: 2
    t.string   "avatar"
    t.boolean  "gender"
    t.string   "address"
    t.string   "phone_number"
    t.string   "chatwork_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["name"], name: "index_users_on_name", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "order_products", "orders"
  add_foreign_key "order_products", "products"
  add_foreign_key "orders", "users"
  add_foreign_key "products", "categories"
  add_foreign_key "ratings", "products"
  add_foreign_key "ratings", "users"
  add_foreign_key "suggestions", "users"
end
