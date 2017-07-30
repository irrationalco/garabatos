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

ActiveRecord::Schema.define(version: 20170701174241) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "product_tickets", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "ticket_id"
    t.float "ammount"
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_tickets_on_product_id"
    t.index ["ticket_id"], name: "index_product_tickets_on_ticket_id"
  end

  create_table "products", force: :cascade do |t|
    t.text "name"
    t.text "types", array: true
    t.text "categories", array: true
    t.text "sets", array: true
    t.text "codes", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_types", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shifts", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.bigint "unit_id"
    t.datetime "time"
    t.integer "number"
    t.bigint "shift_id"
    t.bigint "service_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_type_id"], name: "index_tickets_on_service_type_id"
    t.index ["shift_id"], name: "index_tickets_on_shift_id"
    t.index ["unit_id"], name: "index_tickets_on_unit_id"
  end

  create_table "units", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "product_tickets", "products"
  add_foreign_key "product_tickets", "tickets"
  add_foreign_key "tickets", "service_types"
  add_foreign_key "tickets", "shifts"
  add_foreign_key "tickets", "units"
end
