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

ActiveRecord::Schema[8.0].define(version: 8) do
  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at", precision: nil
    t.datetime "locked_at", precision: nil
    t.datetime "failed_at", precision: nil
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "rails_performance_custom_records", force: :cascade do |t|
    t.string "tag_name", null: false
    t.string "namespace_name", null: false
    t.string "datetime", null: false
    t.bigint "datetimei", null: false
    t.string "status"
    t.float "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["datetime"], name: "index_rails_performance_custom_records_on_datetime"
    t.index ["datetimei"], name: "index_rails_performance_custom_records_on_datetimei"
    t.index ["namespace_name"], name: "index_rails_performance_custom_records_on_namespace_name"
    t.index ["status"], name: "index_rails_performance_custom_records_on_status"
    t.index ["tag_name"], name: "index_rails_performance_custom_records_on_tag_name"
  end

  create_table "rails_performance_delayed_job_records", force: :cascade do |t|
    t.string "jid", null: false
    t.string "datetime", null: false
    t.bigint "datetimei", null: false
    t.string "source_type"
    t.string "class_name"
    t.string "method_name"
    t.string "status"
    t.float "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["class_name"], name: "index_rails_performance_delayed_job_records_on_class_name"
    t.index ["datetime"], name: "index_rails_performance_delayed_job_records_on_datetime"
    t.index ["datetimei"], name: "index_rails_performance_delayed_job_records_on_datetimei"
    t.index ["jid"], name: "index_rails_performance_delayed_job_records_on_jid", unique: true
    t.index ["status"], name: "index_rails_performance_delayed_job_records_on_status"
  end

  create_table "rails_performance_grape_records", force: :cascade do |t|
    t.string "request_id", null: false
    t.string "datetime", null: false
    t.bigint "datetimei", null: false
    t.string "format"
    t.string "path"
    t.integer "status"
    t.string "method"
    t.float "endpoint_render_grape"
    t.float "endpoint_run_grape"
    t.float "format_response_grape"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["datetime"], name: "index_rails_performance_grape_records_on_datetime"
    t.index ["datetimei"], name: "index_rails_performance_grape_records_on_datetimei"
    t.index ["method"], name: "index_rails_performance_grape_records_on_method"
    t.index ["path"], name: "index_rails_performance_grape_records_on_path"
    t.index ["request_id"], name: "index_rails_performance_grape_records_on_request_id", unique: true
    t.index ["status"], name: "index_rails_performance_grape_records_on_status"
  end

  create_table "rails_performance_rake_records", force: :cascade do |t|
    t.text "task", null: false
    t.string "datetime", null: false
    t.bigint "datetimei", null: false
    t.string "status"
    t.float "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["datetime"], name: "index_rails_performance_rake_records_on_datetime"
    t.index ["datetimei"], name: "index_rails_performance_rake_records_on_datetimei"
    t.index ["status"], name: "index_rails_performance_rake_records_on_status"
  end

  create_table "rails_performance_request_records", force: :cascade do |t|
    t.string "controller", null: false
    t.string "action", null: false
    t.string "format", null: false
    t.integer "status", null: false
    t.string "datetime", null: false
    t.bigint "datetimei", null: false
    t.string "method", null: false
    t.string "path", null: false
    t.string "request_id", null: false
    t.float "view_runtime"
    t.float "db_runtime"
    t.float "duration"
    t.string "http_referer"
    t.text "custom_data"
    t.text "exception"
    t.text "backtrace"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["controller", "action"], name: "index_rails_performance_request_records_on_controller_and_action"
    t.index ["datetime"], name: "index_rails_performance_request_records_on_datetime"
    t.index ["datetimei"], name: "index_rails_performance_request_records_on_datetimei"
    t.index ["method"], name: "index_rails_performance_request_records_on_method"
    t.index ["path"], name: "index_rails_performance_request_records_on_path"
    t.index ["request_id"], name: "index_rails_performance_request_records_on_request_id", unique: true
    t.index ["status"], name: "index_rails_performance_request_records_on_status"
  end

  create_table "rails_performance_resource_records", force: :cascade do |t|
    t.string "server", null: false
    t.string "context", null: false
    t.string "role", null: false
    t.string "datetime", null: false
    t.bigint "datetimei", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["context"], name: "index_rails_performance_resource_records_on_context"
    t.index ["datetime"], name: "index_rails_performance_resource_records_on_datetime"
    t.index ["datetimei"], name: "index_rails_performance_resource_records_on_datetimei"
    t.index ["role"], name: "index_rails_performance_resource_records_on_role"
    t.index ["server"], name: "index_rails_performance_resource_records_on_server"
  end

  create_table "rails_performance_sidekiq_records", force: :cascade do |t|
    t.string "queue", null: false
    t.string "worker", null: false
    t.string "jid", null: false
    t.string "datetime", null: false
    t.bigint "datetimei", null: false
    t.bigint "enqueued_ati"
    t.bigint "start_timei"
    t.string "status"
    t.float "duration"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["datetime"], name: "index_rails_performance_sidekiq_records_on_datetime"
    t.index ["datetimei"], name: "index_rails_performance_sidekiq_records_on_datetimei"
    t.index ["jid"], name: "index_rails_performance_sidekiq_records_on_jid", unique: true
    t.index ["queue"], name: "index_rails_performance_sidekiq_records_on_queue"
    t.index ["status"], name: "index_rails_performance_sidekiq_records_on_status"
    t.index ["worker"], name: "index_rails_performance_sidekiq_records_on_worker"
  end

  create_table "rails_performance_trace_records", force: :cascade do |t|
    t.string "request_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_rails_performance_trace_records_on_request_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.integer "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
