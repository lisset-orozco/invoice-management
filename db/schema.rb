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

ActiveRecord::Schema[7.0].define(version: 2022_11_01_231411) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "invoices", comment: "Invoices table", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "invoice_uuid", limit: 36, null: false
    t.string "status", default: "active", null: false
    t.string "emitter_name", null: false
    t.string "emitter_rfc", null: false
    t.string "receiver_name", null: false
    t.string "receiver_rfc", null: false
    t.bigint "amount", null: false
    t.string "currency", null: false
    t.datetime "emitted_at", null: false
    t.datetime "expires_at", null: false
    t.datetime "signed_at", null: false
    t.text "cfdi_digital_stamp", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "users", comment: "Table of users", force: :cascade do |t|
    t.string "rfc", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["rfc"], name: "index_users_on_rfc", unique: true
  end

  add_foreign_key "invoices", "users"
end
