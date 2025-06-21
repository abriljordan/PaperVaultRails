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

ActiveRecord::Schema[8.0].define(version: 6) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "document_shares", force: :cascade do |t|
    t.bigint "document_id", null: false
    t.bigint "user_id", null: false
    t.bigint "shared_by_id", null: false
    t.string "permission", default: "view"
    t.datetime "shared_at", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id", "user_id"], name: "index_document_shares_on_document_id_and_user_id", unique: true
    t.index ["document_id"], name: "index_document_shares_on_document_id"
    t.index ["permission"], name: "index_document_shares_on_permission"
    t.index ["shared_by_id"], name: "index_document_shares_on_shared_by_id"
    t.index ["user_id"], name: "index_document_shares_on_user_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id", null: false
    t.bigint "folder_id"
    t.bigint "file_size", default: 0
    t.string "file_type"
    t.string "file_extension"
    t.boolean "is_starred", default: false
    t.datetime "starred_at"
    t.datetime "last_accessed_at"
    t.integer "access_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["file_type"], name: "index_documents_on_file_type"
    t.index ["folder_id"], name: "index_documents_on_folder_id"
    t.index ["is_starred"], name: "index_documents_on_is_starred"
    t.index ["last_accessed_at"], name: "index_documents_on_last_accessed_at"
    t.index ["user_id", "folder_id", "name"], name: "index_documents_on_user_id_and_folder_id_and_name", unique: true
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "folder_shares", force: :cascade do |t|
    t.bigint "folder_id", null: false
    t.bigint "user_id", null: false
    t.bigint "shared_by_id", null: false
    t.string "permission", default: "view"
    t.datetime "shared_at", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["folder_id", "user_id"], name: "index_folder_shares_on_folder_id_and_user_id", unique: true
    t.index ["folder_id"], name: "index_folder_shares_on_folder_id"
    t.index ["permission"], name: "index_folder_shares_on_permission"
    t.index ["shared_by_id"], name: "index_folder_shares_on_shared_by_id"
    t.index ["user_id"], name: "index_folder_shares_on_user_id"
  end

  create_table "folders", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id", null: false
    t.bigint "parent_id"
    t.string "color", default: "#4285f4"
    t.boolean "is_starred", default: false
    t.datetime "starred_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_starred"], name: "index_folders_on_is_starred"
    t.index ["parent_id"], name: "index_folders_on_parent_id"
    t.index ["user_id", "parent_id", "name"], name: "index_folders_on_user_id_and_parent_id_and_name", unique: true
    t.index ["user_id"], name: "index_folders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "document_shares", "documents"
  add_foreign_key "document_shares", "users"
  add_foreign_key "document_shares", "users", column: "shared_by_id"
  add_foreign_key "documents", "folders"
  add_foreign_key "documents", "users"
  add_foreign_key "folder_shares", "folders"
  add_foreign_key "folder_shares", "users"
  add_foreign_key "folder_shares", "users", column: "shared_by_id"
  add_foreign_key "folders", "folders", column: "parent_id"
  add_foreign_key "folders", "users"
end
