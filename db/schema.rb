# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160809082818) do

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "failed_attempts",        limit: 4,   default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  add_index "admin_users", ["unlock_token"], name: "index_admin_users_on_unlock_token", unique: true, using: :btree

  create_table "casino_auth_token_tickets", force: :cascade do |t|
    t.string   "ticket",     limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "casino_auth_token_tickets", ["ticket"], name: "index_casino_auth_token_tickets_on_ticket", unique: true, using: :btree

  create_table "casino_login_attempts", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,                     null: false
    t.boolean  "successful",               default: false
    t.string   "user_ip",    limit: 255
    t.text     "user_agent", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "casino_login_tickets", force: :cascade do |t|
    t.string   "ticket",     limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "casino_login_tickets", ["ticket"], name: "index_casino_login_tickets_on_ticket", unique: true, using: :btree

  create_table "casino_proxy_granting_tickets", force: :cascade do |t|
    t.string   "ticket",       limit: 255, null: false
    t.string   "iou",          limit: 255, null: false
    t.integer  "granter_id",   limit: 4,   null: false
    t.string   "pgt_url",      limit: 255, null: false
    t.string   "granter_type", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "casino_proxy_granting_tickets", ["granter_type", "granter_id"], name: "index_casino_proxy_granting_tickets_on_granter", unique: true, using: :btree
  add_index "casino_proxy_granting_tickets", ["granter_type", "granter_id"], name: "index_proxy_granting_tickets_on_granter", unique: true, using: :btree
  add_index "casino_proxy_granting_tickets", ["iou"], name: "index_casino_proxy_granting_tickets_on_iou", unique: true, using: :btree
  add_index "casino_proxy_granting_tickets", ["ticket"], name: "index_casino_proxy_granting_tickets_on_ticket", unique: true, using: :btree

  create_table "casino_proxy_tickets", force: :cascade do |t|
    t.string   "ticket",                   limit: 255,                   null: false
    t.text     "service",                  limit: 65535,                 null: false
    t.boolean  "consumed",                               default: false, null: false
    t.integer  "proxy_granting_ticket_id", limit: 4,                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "casino_proxy_tickets", ["proxy_granting_ticket_id"], name: "casino_proxy_tickets_on_pgt_id", using: :btree
  add_index "casino_proxy_tickets", ["ticket"], name: "index_casino_proxy_tickets_on_ticket", unique: true, using: :btree

  create_table "casino_service_rules", force: :cascade do |t|
    t.boolean  "enabled",                default: true,  null: false
    t.integer  "order",      limit: 4,   default: 10,    null: false
    t.string   "name",       limit: 255,                 null: false
    t.string   "url",        limit: 255,                 null: false
    t.boolean  "regex",                  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "casino_service_rules", ["url"], name: "index_casino_service_rules_on_url", unique: true, using: :btree

  create_table "casino_service_tickets", force: :cascade do |t|
    t.string   "ticket",                    limit: 255,                   null: false
    t.text     "service",                   limit: 65535,                 null: false
    t.integer  "ticket_granting_ticket_id", limit: 4
    t.boolean  "consumed",                                default: false, null: false
    t.boolean  "issued_from_credentials",                 default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "casino_service_tickets", ["ticket"], name: "index_casino_service_tickets_on_ticket", unique: true, using: :btree
  add_index "casino_service_tickets", ["ticket_granting_ticket_id"], name: "casino_service_tickets_on_tgt_id", using: :btree

  create_table "casino_ticket_granting_tickets", force: :cascade do |t|
    t.string   "ticket",                             limit: 255,                   null: false
    t.text     "user_agent",                         limit: 65535
    t.integer  "user_id",                            limit: 4,                     null: false
    t.boolean  "awaiting_two_factor_authentication",               default: false, null: false
    t.boolean  "long_term",                                        default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_ip",                            limit: 255
  end

  add_index "casino_ticket_granting_tickets", ["ticket"], name: "index_casino_ticket_granting_tickets_on_ticket", unique: true, using: :btree

  create_table "casino_two_factor_authenticators", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,                   null: false
    t.string   "secret",     limit: 255,                 null: false
    t.boolean  "active",                 default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "casino_two_factor_authenticators", ["user_id"], name: "index_casino_two_factor_authenticators_on_user_id", using: :btree

  create_table "casino_users", force: :cascade do |t|
    t.string   "authenticator",    limit: 255,   null: false
    t.string   "username",         limit: 255,   null: false
    t.text     "extra_attributes", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "casino_users", ["authenticator", "username"], name: "index_casino_users_on_authenticator_and_username", unique: true, using: :btree

  create_table "phone_verifications", force: :cascade do |t|
    t.string   "phone",      limit: 255
    t.string   "pin",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "service_permissions", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "fullname",      limit: 1
    t.integer  "gender",        limit: 1
    t.integer  "birthday",      limit: 1
    t.integer  "identity_card", limit: 1
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "service_permissions", ["name"], name: "index_service_permissions_on_name", using: :btree

  create_table "user_extras", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.string   "fullname",      limit: 255
    t.integer  "gender",        limit: 4
    t.date     "birthday"
    t.string   "identity_card", limit: 18
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "user_extras", ["user_id"], name: "index_user_extras_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.string   "email",                limit: 255
    t.string   "phone",                limit: 255
    t.string   "password_digest",      limit: 255
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "confirmation_digest",  limit: 255
    t.boolean  "confirmed",                        default: false
    t.datetime "confirmed_at"
    t.string   "reset_digest",         limit: 255
    t.datetime "reset_sent_at"
    t.string   "reset_pin",            limit: 255
    t.datetime "reset_pin_sent_at"
    t.string   "new_email",            limit: 255
    t.string   "avatar",               limit: 255
    t.string   "register_from",        limit: 255
    t.date     "confirmation_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["phone"], name: "index_users_on_phone", using: :btree

  add_foreign_key "user_extras", "users"
end
