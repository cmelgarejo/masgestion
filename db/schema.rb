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

ActiveRecord::Schema.define(version: 108) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "campaign_details", id: false, force: :cascade do |t|
    t.uuid     "campaign_id"
    t.uuid     "client_id"
    t.integer  "user_id"
    t.text     "observations"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["campaign_id"], name: "index_campaign_details_on_campaign_id", using: :btree
    t.index ["client_id"], name: "index_campaign_details_on_client_id", using: :btree
    t.index ["user_id"], name: "index_campaign_details_on_user_id", using: :btree
  end

  create_table "campaigns", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name",                        null: false
    t.date     "start"
    t.date     "end"
    t.integer  "status",       default: 0
    t.boolean  "active",       default: true
    t.uuid     "portfolio_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["portfolio_id"], name: "index_campaigns_on_portfolio_id", using: :btree
  end

  create_table "client_collection_categories", force: :cascade do |t|
    t.string   "description", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["description"], name: "index_client_collection_categories_on_description", using: :btree
  end

  create_table "client_collection_history", force: :cascade do |t|
    t.uuid     "client_id"
    t.integer  "client_collection_category_id"
    t.integer  "client_collection_type_id"
    t.integer  "user_id"
    t.decimal  "promise_amount",                default: "0.0"
    t.date     "promise_date"
    t.text     "observations"
    t.boolean  "debt_collector",                default: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "history_type_id"
    t.integer  "client_product_id"
    t.integer  "client_contact_means_id"
    t.index ["client_collection_category_id"], name: "index_client_collection_history_on_category_id", using: :btree
    t.index ["client_collection_type_id"], name: "index_client_collection_history_on_category_type_id", using: :btree
    t.index ["client_contact_means_id"], name: "index_client_collection_history_on_client_contact_means_id", using: :btree
    t.index ["client_id"], name: "index_client_collection_history_on_client_id", using: :btree
    t.index ["client_product_id"], name: "index_client_collection_history_on_client_product_id", using: :btree
    t.index ["history_type_id"], name: "index_client_collection_history_on_history_type_id", using: :btree
    t.index ["user_id"], name: "index_client_collection_history_on_user_id", using: :btree
  end

  create_table "client_collection_types", force: :cascade do |t|
    t.string   "description", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["description"], name: "index_client_collection_types_on_description", using: :btree
  end

  create_table "client_contact_means", force: :cascade do |t|
    t.integer  "contact_mean_types_id"
    t.uuid     "client_id"
    t.string   "target",                               null: false
    t.text     "observations"
    t.boolean  "active",                default: true
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.index ["client_id"], name: "index_client_contact_means_on_client_id", using: :btree
    t.index ["contact_mean_types_id"], name: "index_client_contact_means_on_contact_mean_types_id", using: :btree
  end

  create_table "client_product_payments", force: :cascade do |t|
    t.uuid     "client_id"
    t.integer  "client_product_id"
    t.decimal  "value",             default: "0.0"
    t.date     "payment_date"
    t.text     "observations"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["client_id"], name: "index_client_product_payments_on_client_id", using: :btree
    t.index ["client_product_id"], name: "index_client_product_payments_on_client_product_id", using: :btree
  end

  create_table "client_products", force: :cascade do |t|
    t.uuid     "client_id"
    t.integer  "company_product_id"
    t.decimal  "balance",            default: "0.0"
    t.decimal  "arrears",            default: "0.0"
    t.decimal  "total_with_arrears", default: "0.0"
    t.integer  "days_late",          default: 0
    t.text     "observations"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["client_id"], name: "index_client_products_on_client_id", using: :btree
    t.index ["company_product_id", "client_id"], name: "index_client_products_on_company_product_id_and_client_id", using: :btree
    t.index ["company_product_id"], name: "index_client_products_on_company_product_id", using: :btree
  end

  create_table "client_references", force: :cascade do |t|
    t.uuid     "client_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.text     "observations"
    t.boolean  "active",       default: true
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["client_id"], name: "index_client_references_on_client_id", using: :btree
  end

  create_table "clients", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "first_name",                      null: false
    t.string   "last_name",                       null: false
    t.integer  "document_type_id",                null: false
    t.string   "document",                        null: false
    t.date     "birthdate"
    t.string   "address"
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.float    "lat"
    t.float    "lng"
    t.boolean  "active",           default: true
    t.uuid     "company_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "ref_code"
    t.jsonb    "original_data"
    t.index "point(lat, lng)", name: "index_clients_latlng_spgist", using: :spgist
    t.index ["company_id"], name: "index_clients_on_company_id", using: :btree
    t.index ["country", "state", "city"], name: "index_clients_on_country_and_state_and_city", using: :btree
    t.index ["country", "state"], name: "index_clients_on_country_and_state", using: :btree
    t.index ["document_type_id", "document"], name: "index_clients_on_document_type_id_and_document", using: :btree
    t.index ["document_type_id"], name: "index_clients_on_document_type_id", using: :btree
  end

  create_table "companies", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "description"
    t.boolean  "active"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "ref_code"
  end

  create_table "company_products", force: :cascade do |t|
    t.uuid     "company_id"
    t.integer  "product_type_id"
    t.string   "description"
    t.boolean  "active"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "ref_code"
    t.index ["company_id"], name: "index_company_products_on_company_id", using: :btree
    t.index ["product_type_id"], name: "index_company_products_on_product_type_id", using: :btree
  end

  create_table "contact_mean_types", force: :cascade do |t|
    t.string   "description", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["description"], name: "index_contact_mean_types_on_description", using: :btree
  end

  create_table "document_types", force: :cascade do |t|
    t.string   "description", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["description"], name: "index_document_types_on_description", using: :btree
  end

  create_table "history_types", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "opportunities", force: :cascade do |t|
    t.uuid     "company_id"
    t.integer  "user_id"
    t.string   "name",                        null: false
    t.integer  "stage"
    t.date     "close_date"
    t.float    "probability", default: 0.0
    t.decimal  "amount",      default: "0.0"
    t.decimal  "discount",    default: "0.0"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["company_id"], name: "index_opportunities_on_company_id", using: :btree
    t.index ["user_id"], name: "index_opportunities_on_user_id", using: :btree
  end

  create_table "portfolios", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "company_id"
    t.string   "name",                      null: false
    t.boolean  "active",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["company_id"], name: "index_portfolios_on_company_id", using: :btree
  end

  create_table "product_types", force: :cascade do |t|
    t.string   "description", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "task_categories", force: :cascade do |t|
    t.string   "description", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["description"], name: "index_task_categories_on_description", using: :btree
  end

  create_table "tasks", force: :cascade do |t|
    t.integer  "user_id"
    t.uuid     "client_id"
    t.integer  "task_category_id"
    t.string   "name",             null: false
    t.date     "due"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["client_id"], name: "index_tasks_on_client_id", using: :btree
    t.index ["task_category_id"], name: "index_tasks_on_task_category_id", using: :btree
    t.index ["user_id", "client_id"], name: "index_tasks_on_user_id_and_client_id", using: :btree
    t.index ["user_id"], name: "index_tasks_on_user_id", using: :btree
  end

  create_table "user_companies", id: false, force: :cascade do |t|
    t.integer  "user_id"
    t.uuid     "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_user_companies_on_company_id", using: :btree
    t.index ["user_id", "company_id"], name: "index_user_companies_on_user_id_and_company_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_user_companies_on_user_id", using: :btree
  end

  create_table "user_roles", id: false, force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id", using: :btree
    t.index ["user_id", "role_id"], name: "index_user_roles_on_user_id_and_role_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_user_roles_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "name"
    t.integer  "role"
    t.uuid     "company_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["company_id"], name: "index_users_on_company_id", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string  "foreign_key_name", null: false
    t.integer "foreign_key_id"
    t.index ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key", using: :btree
    t.index ["version_id"], name: "index_version_associations_on_version_id", using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

  add_foreign_key "campaign_details", "campaigns"
  add_foreign_key "campaign_details", "clients"
  add_foreign_key "campaign_details", "users"
  add_foreign_key "campaigns", "portfolios"
  add_foreign_key "client_collection_history", "client_collection_categories"
  add_foreign_key "client_collection_history", "client_collection_types"
  add_foreign_key "client_collection_history", "client_contact_means", column: "client_contact_means_id"
  add_foreign_key "client_collection_history", "client_products"
  add_foreign_key "client_collection_history", "clients"
  add_foreign_key "client_collection_history", "history_types"
  add_foreign_key "client_collection_history", "users"
  add_foreign_key "client_contact_means", "clients"
  add_foreign_key "client_contact_means", "contact_mean_types", column: "contact_mean_types_id"
  add_foreign_key "client_product_payments", "client_products"
  add_foreign_key "client_product_payments", "clients"
  add_foreign_key "client_products", "clients"
  add_foreign_key "client_products", "company_products"
  add_foreign_key "client_references", "clients"
  add_foreign_key "clients", "document_types"
  add_foreign_key "company_products", "companies"
  add_foreign_key "company_products", "product_types"
  add_foreign_key "opportunities", "companies"
  add_foreign_key "portfolios", "companies"
end
