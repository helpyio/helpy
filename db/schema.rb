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

ActiveRecord::Schema.define(version: 20191005134018) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token"
    t.integer  "user_id"
    t.string   "name"
    t.datetime "date_expired"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "api_keys", ["access_token"], name: "index_api_keys_on_access_token", unique: true, using: :btree
  add_index "api_keys", ["user_id"], name: "index_api_keys_on_user_id", using: :btree

  create_table "attachinary_files", force: :cascade do |t|
    t.integer  "attachinariable_id"
    t.string   "attachinariable_type"
    t.string   "scope"
    t.string   "public_id"
    t.string   "version"
    t.integer  "width"
    t.integer  "height"
    t.string   "format"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachinary_files", ["attachinariable_type", "attachinariable_id", "scope"], name: "by_scoped_parent", using: :btree

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "backups", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "csv"
    t.string   "model"
    t.string   "csv_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "backups", ["user_id"], name: "index_backups_on_user_id", using: :btree

  create_table "boxes", force: :cascade do |t|
    t.string   "label"
    t.string   "name"
    t.text     "description"
    t.integer  "rank"
    t.text     "query"
    t.boolean  "default"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "icon"
    t.string   "keywords"
    t.string   "title_tag"
    t.string   "meta_description"
    t.integer  "rank"
    t.boolean  "front_page",       default: false
    t.boolean  "active",           default: true
    t.string   "permalink"
    t.string   "section"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "visibility",       default: "all"
    t.string   "ancestry"
  end

  add_index "categories", ["ancestry"], name: "index_categories_on_ancestry", using: :btree

  create_table "category_translations", force: :cascade do |t|
    t.integer  "category_id",      null: false
    t.string   "locale",           null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "name"
    t.string   "keywords"
    t.string   "title_tag"
    t.string   "meta_description"
  end

  add_index "category_translations", ["category_id"], name: "index_category_translations_on_category_id", using: :btree
  add_index "category_translations", ["locale"], name: "index_category_translations_on_locale", using: :btree

  create_table "doc_translations", force: :cascade do |t|
    t.integer  "doc_id",           null: false
    t.string   "locale",           null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "title"
    t.text     "body"
    t.string   "keywords"
    t.string   "title_tag"
    t.string   "meta_description"
  end

  add_index "doc_translations", ["doc_id"], name: "index_doc_translations_on_doc_id", using: :btree
  add_index "doc_translations", ["locale"], name: "index_doc_translations_on_locale", using: :btree

  create_table "doc_views", force: :cascade do |t|
    t.string   "collector_action", default: "view"
    t.integer  "user_id"
    t.string   "session_id"
    t.integer  "doc_id"
    t.string   "doc_title"
    t.integer  "category_id"
    t.string   "doc_category"
    t.string   "search_used"
    t.text     "referrer"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "results_found",    default: 0
  end

  add_index "doc_views", ["doc_id"], name: "index_doc_views_on_doc_id", using: :btree

  create_table "docs", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.string   "keywords"
    t.string   "title_tag"
    t.string   "meta_description"
    t.integer  "category_id"
    t.integer  "user_id"
    t.boolean  "active",           default: true
    t.integer  "rank"
    t.string   "permalink"
    t.integer  "version"
    t.boolean  "front_page",       default: false
    t.boolean  "cheatsheet",       default: false
    t.integer  "points",           default: 0
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "topics_count",     default: 0
    t.boolean  "allow_comments",   default: true
    t.string   "attachments",      default: [],                 array: true
    t.integer  "doc_views_count",  default: 0
  end

  create_table "flags", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "generated_topic_id"
    t.text     "reason"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "followers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "followers", ["topic_id"], name: "index_followers_on_topic_id", using: :btree
  add_index "followers", ["user_id"], name: "index_followers_on_user_id", using: :btree

  create_table "forums", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "topics_count",       default: 0,       null: false
    t.datetime "last_post_date"
    t.integer  "last_post_id"
    t.boolean  "private",            default: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.boolean  "allow_topic_voting", default: false
    t.boolean  "allow_post_voting",  default: false
    t.string   "layout",             default: "table"
  end

  create_table "images", force: :cascade do |t|
    t.string   "key"
    t.string   "name"
    t.string   "extension"
    t.text     "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "imports", force: :cascade do |t|
    t.string   "status"
    t.string   "notes"
    t.string   "model"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.integer  "submited_record_count"
    t.text     "imported_ids"
    t.text     "error_log"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "key_values", force: :cascade do |t|
    t.string   "key"
    t.text     "value"
    t.integer  "kvable_id"
    t.string   "kvable_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "key_values", ["kvable_id", "kvable_type"], name: "kvable_index", using: :btree
  add_index "key_values", ["value"], name: "kv_value_index", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "recipient_id"
    t.integer  "actor_id"
    t.datetime "read_at"
    t.boolean  "send_email",      default: false
    t.datetime "sent_at"
    t.string   "action"
    t.string   "title"
    t.text     "message"
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.datetime "alerted_at"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "topic_id"
    t.integer  "user_id"
    t.text     "body"
    t.string   "kind"
    t.boolean  "active",           default: true
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "points",           default: 0
    t.string   "attachments",      default: [],                array: true
    t.string   "cc"
    t.string   "bcc"
    t.text     "raw_email"
    t.string   "email_to_address", default: ""
  end

  create_table "ratings", force: :cascade do |t|
    t.integer  "topic_id"
    t.integer  "score"
    t.text     "comments"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ratings", ["topic_id"], name: "index_ratings_on_topic_id", using: :btree
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id", using: :btree

  create_table "searches", force: :cascade do |t|
    t.string   "name"
    t.text     "body"
    t.string   "search_type"
    t.integer  "search_id"
    t.datetime "last_updated_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "sla_schedules", force: :cascade do |t|
    t.integer  "topic_id"
    t.integer  "sla_id"
    t.integer  "post_id"
    t.datetime "wait_until"
    t.datetime "job_run"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "slas", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "event"
    t.string   "priority"
    t.integer  "time"
    t.integer  "time_units",                 default: 60
    t.integer  "minutes"
    t.string   "tags"
    t.string   "group"
    t.integer  "assigned_user_id"
    t.text     "note"
    t.string   "notify_users",                                            array: true
    t.boolean  "active",                     default: true
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "selected_groups",                                         array: true
    t.string   "selected_ticket_priorities",                              array: true
    t.string   "selected_user_priorities",                                array: true
    t.boolean  "set_hours",                  default: false
    t.boolean  "monday_active",              default: false
    t.integer  "monday_start",               default: 9
    t.integer  "monday_end",                 default: 18
    t.boolean  "tuesday_active",             default: false
    t.integer  "tuesday_start",              default: 9
    t.integer  "tuesday_end",                default: 18
    t.boolean  "wednesday_active",           default: false
    t.integer  "wednesday_start",            default: 9
    t.integer  "wednesday_end",              default: 18
    t.boolean  "thursday_active",            default: false
    t.integer  "thursday_start",             default: 9
    t.integer  "thursday_end",               default: 18
    t.boolean  "friday_active",              default: false
    t.integer  "friday_start",               default: 9
    t.integer  "friday_end",                 default: 18
    t.boolean  "saturday_active",            default: false
    t.integer  "saturday_start",             default: 9
    t.integer  "saturday_end",               default: 18
    t.boolean  "sunday_active",              default: false
    t.integer  "sunday_start",               default: 9
    t.integer  "sunday_end",                 default: 18
    t.string   "time_zone",                  default: "UTC"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count",     default: 0
    t.boolean "show_on_helpcenter", default: false
    t.boolean "show_on_admin",      default: false
    t.boolean "show_on_dashboard",  default: false
    t.text    "description"
    t.string  "color"
    t.boolean "active",             default: true
    t.string  "email_address"
    t.string  "email_name"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "topic_fields", force: :cascade do |t|
    t.string   "name"
    t.string   "label"
    t.string   "field_type"
    t.string   "select_options"
    t.boolean  "required"
    t.string   "class_names"
    t.integer  "rank"
    t.string   "group"
    t.string   "toggle_target"
    t.boolean  "display_on_helpcenter"
    t.boolean  "display_on_admin"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "valid_value"
  end

  create_table "topics", force: :cascade do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.string   "user_name"
    t.string   "name"
    t.integer  "posts_count",      default: 0,        null: false
    t.string   "waiting_on",       default: "admin",  null: false
    t.datetime "last_post_date"
    t.datetime "closed_date"
    t.integer  "last_post_id"
    t.string   "current_status",   default: "new",    null: false
    t.boolean  "private",          default: false
    t.integer  "assigned_user_id"
    t.boolean  "cheatsheet",       default: false
    t.integer  "points",           default: 0
    t.text     "post_cache"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "locale"
    t.integer  "doc_id",           default: 0
    t.string   "channel",          default: "email"
    t.string   "kind",             default: "ticket"
    t.integer  "priority",         default: 1
    t.string   "condition",        default: "green"
    t.string   "sentiment"
    t.datetime "last"
    t.decimal  "spam_score",       default: 0.0
    t.text     "spam_report",      default: ""
  end

  add_index "topics", ["kind"], name: "index_topics_on_kind", using: :btree
  add_index "topics", ["priority"], name: "index_topics_on_priority", using: :btree

  create_table "trigger_runs", force: :cascade do |t|
    t.integer  "topic_id"
    t.integer  "trigger_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "triggers", force: :cascade do |t|
    t.string   "name"
    t.string   "mode",          default: "and"
    t.text     "actions"
    t.text     "conditions"
    t.string   "url"
    t.string   "event"
    t.string   "slack_channel"
    t.boolean  "active",        default: true
    t.integer  "rank"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "login"
    t.string   "identity_url"
    t.string   "name"
    t.boolean  "admin",                  default: false
    t.text     "bio"
    t.text     "signature"
    t.string   "role",                   default: "user"
    t.string   "home_phone"
    t.string   "work_phone"
    t.string   "cell_phone"
    t.string   "company"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "title"
    t.string   "twitter"
    t.string   "linkedin"
    t.string   "thumbnail"
    t.string   "medium_image"
    t.string   "large_image"
    t.string   "language",               default: "en"
    t.integer  "assigned_ticket_count",  default: 0
    t.integer  "topics_count",           default: 0
    t.boolean  "active",                 default: true
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "email",                  default: "",          null: false
    t.string   "encrypted_password",     default: "",          null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,           null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "provider"
    t.string   "uid"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.text     "invitation_message"
    t.string   "time_zone",              default: "UTC"
    t.string   "profile_image"
    t.boolean  "notify_on_private",      default: false
    t.boolean  "notify_on_public",       default: false
    t.boolean  "notify_on_reply",        default: false
    t.string   "account_number"
    t.string   "priority",               default: "normal"
    t.text     "notes"
    t.boolean  "notify_on_assignment",   default: true
    t.boolean  "notify_on_mention",      default: true
    t.string   "status",                 default: "available"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["notify_on_private"], name: "index_users_on_notify_on_private", using: :btree
  add_index "users", ["notify_on_public"], name: "index_users_on_notify_on_public", using: :btree
  add_index "users", ["notify_on_reply"], name: "index_users_on_notify_on_reply", using: :btree
  add_index "users", ["priority"], name: "index_users_on_priority", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.string   "locale"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "violations", force: :cascade do |t|
    t.integer  "topic_id"
    t.integer  "sla_id"
    t.boolean  "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "votes", force: :cascade do |t|
    t.integer  "points",        default: 1
    t.string   "voteable_type"
    t.integer  "voteable_id"
    t.integer  "user_id",       default: 0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

end
