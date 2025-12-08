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

ActiveRecord::Schema[8.1].define(version: 2025_12_08_075020) do
  create_schema "extensions"

  # These are extensions that must be enabled in order to support this database
  enable_extension "extensions.pg_stat_statements"
  enable_extension "extensions.pgcrypto"
  enable_extension "extensions.uuid-ossp"
  enable_extension "graphql.pg_graphql"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "vault.supabase_vault"

  create_table "public.active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "public.active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "public.active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "public.awards", force: :cascade do |t|
    t.string "badge_image"
    t.datetime "created_at", null: false
    t.date "date"
    t.text "description"
    t.string "organization"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_awards_on_user_id"
  end

  create_table "public.blog_posts", force: :cascade do |t|
    t.integer "category_id"
    t.text "content"
    t.string "cover_image"
    t.datetime "created_at", null: false
    t.text "excerpt"
    t.boolean "is_public"
    t.datetime "published_at"
    t.datetime "scheduled_at"
    t.string "slug"
    t.integer "status"
    t.string "subtitle"
    t.text "tags"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "views"
    t.index ["user_id"], name: "index_blog_posts_on_user_id"
  end

  create_table "public.books", force: :cascade do |t|
    t.string "author", null: false
    t.text "categories"
    t.string "cover_image"
    t.datetime "created_at", null: false
    t.date "end_date"
    t.integer "pages"
    t.string "publisher"
    t.integer "rating"
    t.text "review"
    t.date "start_date"
    t.string "status", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_books_on_user_id"
  end

  create_table "public.categories", force: :cascade do |t|
    t.string "color"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "icon"
    t.string "name"
    t.integer "parent_id"
    t.integer "post_count"
    t.string "slug"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "public.comment_likes", force: :cascade do |t|
    t.bigint "comment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["comment_id", "user_id"], name: "index_comment_likes_on_comment_id_and_user_id", unique: true
    t.index ["comment_id"], name: "index_comment_likes_on_comment_id"
    t.index ["user_id"], name: "index_comment_likes_on_user_id"
  end

  create_table "public.comments", force: :cascade do |t|
    t.integer "commentable_id", null: false
    t.string "commentable_type", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.integer "depth", default: 0, null: false
    t.integer "likes_count", default: 0, null: false
    t.string "locale", default: "en", null: false
    t.integer "parent_id"
    t.string "path", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["commentable_type", "commentable_id", "locale"], name: "idx_on_commentable_type_commentable_id_locale_fcdf997776"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["locale"], name: "index_comments_on_locale"
    t.index ["parent_id"], name: "index_comments_on_parent_id"
    t.index ["path"], name: "index_comments_on_path"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "public.hire_requests", force: :cascade do |t|
    t.string "company"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.text "message"
    t.string "name", null: false
    t.string "schedule_iso", null: false
    t.string "status", default: "new", null: false
    t.datetime "updated_at", null: false
  end

  create_table "public.milestones", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "details"
    t.string "location"
    t.string "milestone_type", null: false
    t.string "organization"
    t.string "period", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_milestones_on_user_id"
  end

  create_table "public.project_blog_posts", force: :cascade do |t|
    t.string "category", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.integer "order", default: 0
    t.integer "project_id", null: false
    t.string "slug", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "velog_comments", default: 0
    t.integer "velog_likes", default: 0
    t.string "velog_post_id"
    t.datetime "velog_synced_at"
    t.string "velog_url"
    t.integer "velog_views", default: 0
    t.index ["project_id", "category", "slug"], name: "index_project_blog_posts_unique", unique: true
    t.index ["project_id"], name: "index_project_blog_posts_on_project_id"
  end

  create_table "public.projects", force: :cascade do |t|
    t.string "blog_folder"
    t.string "cover_image"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "demo_url"
    t.text "description"
    t.date "end_date"
    t.boolean "is_ongoing", default: false, null: false
    t.text "itinerary"
    t.string "repo_url"
    t.string "slug"
    t.text "souvenirs"
    t.text "stack"
    t.date "start_date"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["deleted_at"], name: "index_projects_on_deleted_at"
    t.index ["slug"], name: "index_projects_on_slug", unique: true
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "public.reading_goals", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "current_books", default: 0, null: false
    t.integer "target_books", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "year", null: false
    t.index ["user_id"], name: "index_reading_goals_on_user_id"
  end

  create_table "public.site_settings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key"
    t.datetime "updated_at", null: false
    t.text "value"
    t.index ["key"], name: "index_site_settings_on_key", unique: true
  end

  create_table "public.tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "post_count"
    t.string "slug"
    t.datetime "updated_at", null: false
    t.integer "usage_count"
  end

  create_table "public.translations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "field_name", null: false
    t.string "locale", null: false
    t.integer "translatable_id", null: false
    t.string "translatable_type", null: false
    t.datetime "updated_at", null: false
    t.text "value"
    t.index ["translatable_type", "translatable_id", "locale", "field_name"], name: "index_translations_unique", unique: true
    t.index ["translatable_type", "translatable_id", "locale"], name: "index_translations_by_record_locale"
  end

  create_table "public.travel_diaries", force: :cascade do |t|
    t.text "companions"
    t.datetime "created_at", null: false
    t.text "days"
    t.text "description"
    t.string "destination_city", null: false
    t.string "destination_code"
    t.string "destination_country", null: false
    t.date "end_date", null: false
    t.text "expenses"
    t.boolean "is_public", default: false, null: false
    t.text "photos"
    t.integer "rating"
    t.date "start_date", null: false
    t.text "tags"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_travel_diaries_on_user_id"
  end

  create_table "public.travel_plans", force: :cascade do |t|
    t.text "bucket_list"
    t.decimal "budget_amount", precision: 12, scale: 2
    t.string "budget_currency"
    t.text "checklist"
    t.datetime "created_at", null: false
    t.string "destination_city", null: false
    t.string "destination_code"
    t.string "destination_country", null: false
    t.integer "duration"
    t.text "itinerary"
    t.text "notes"
    t.string "status", default: "planning", null: false
    t.date "target_date"
    t.integer "time_slot_duration"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_travel_plans_on_user_id"
  end

  create_table "public.uploads", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "public.users", force: :cascade do |t|
    t.text "admin_approved_by"
    t.datetime "admin_invite_expires_at"
    t.string "admin_invite_token"
    t.integer "admin_invited_by"
    t.string "admin_status", default: "active", null: false
    t.text "admin_status_reason"
    t.string "avatar_url"
    t.text "bio"
    t.text "certifications"
    t.string "company"
    t.string "contact_email"
    t.datetime "created_at", null: false
    t.string "currency"
    t.boolean "dark_mode", default: false, null: false
    t.string "email"
    t.boolean "email_notifications", default: true, null: false
    t.string "email_verification_token"
    t.boolean "email_verified"
    t.text "external_links"
    t.string "github_url"
    t.string "job_position"
    t.datetime "last_login_at"
    t.string "linkedin_url"
    t.string "locale"
    t.string "location_city"
    t.string "location_country"
    t.string "name"
    t.string "password_digest"
    t.datetime "password_reset_expires_at"
    t.string "password_reset_token"
    t.string "phone"
    t.text "profile"
    t.string "refresh_token"
    t.string "role", default: "user", null: false
    t.text "skills"
    t.string "tagline"
    t.string "theme_city"
    t.string "theme_country"
    t.string "timezone"
    t.string "twitter_url"
    t.datetime "updated_at", null: false
    t.text "values"
    t.string "website_url"
    t.index ["admin_invite_token"], name: "index_users_on_admin_invite_token", unique: true
    t.index ["admin_status"], name: "index_users_on_admin_status"
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "public.active_storage_attachments", "public.active_storage_blobs", column: "blob_id"
  add_foreign_key "public.active_storage_variant_records", "public.active_storage_blobs", column: "blob_id"
  add_foreign_key "public.awards", "public.users"
  add_foreign_key "public.blog_posts", "public.users"
  add_foreign_key "public.books", "public.users"
  add_foreign_key "public.categories", "public.users"
  add_foreign_key "public.comment_likes", "public.comments"
  add_foreign_key "public.comment_likes", "public.users"
  add_foreign_key "public.comments", "public.comments", column: "parent_id"
  add_foreign_key "public.comments", "public.users"
  add_foreign_key "public.milestones", "public.users"
  add_foreign_key "public.project_blog_posts", "public.projects"
  add_foreign_key "public.projects", "public.users"
  add_foreign_key "public.reading_goals", "public.users"
  add_foreign_key "public.travel_diaries", "public.users"
  add_foreign_key "public.travel_plans", "public.users"

end
