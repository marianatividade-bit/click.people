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

ActiveRecord::Schema[8.1].define(version: 2026_06_11_000006) do
  create_table "cycle_snapshots", force: :cascade do |t|
    t.integer "chapter_manager_id"
    t.datetime "created_at", null: false
    t.integer "cycle_id", null: false
    t.integer "person_id", null: false
    t.integer "stream_manager_id"
    t.index ["chapter_manager_id"], name: "index_cycle_snapshots_on_chapter_manager_id"
    t.index ["cycle_id", "person_id"], name: "index_cycle_snapshots_on_cycle_id_and_person_id", unique: true
    t.index ["cycle_id"], name: "index_cycle_snapshots_on_cycle_id"
    t.index ["person_id"], name: "index_cycle_snapshots_on_person_id"
    t.index ["stream_manager_id"], name: "index_cycle_snapshots_on_stream_manager_id"
  end

  create_table "cycles", force: :cascade do |t|
    t.datetime "closed_at"
    t.datetime "created_at", null: false
    t.date "evaluation_deadline"
    t.string "name", null: false
    t.json "nine_box_config", default: {}, null: false
    t.datetime "opened_at"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_cycles_on_status"
  end

  create_table "evaluations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "cycle_id", null: false
    t.integer "evaluated_id", null: false
    t.integer "evaluator_id", null: false
    t.text "improvements"
    t.text "overall_comment"
    t.float "performance_score"
    t.float "potential_score"
    t.integer "status", default: 0, null: false
    t.text "strengths"
    t.datetime "submitted_at"
    t.datetime "updated_at", null: false
    t.index ["cycle_id", "evaluator_id", "evaluated_id"], name: "idx_evaluations_unique", unique: true
    t.index ["cycle_id"], name: "index_evaluations_on_cycle_id"
    t.index ["evaluated_id"], name: "index_evaluations_on_evaluated_id"
    t.index ["evaluator_id"], name: "index_evaluations_on_evaluator_id"
    t.index ["status"], name: "index_evaluations_on_status"
  end

  create_table "people", force: :cascade do |t|
    t.integer "chapter_manager_id"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", null: false
    t.string "google_uid", null: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "name", null: false
    t.date "offboarded_at"
    t.datetime "org_updated_at"
    t.string "provider", default: "google_oauth2", null: false
    t.datetime "remember_created_at"
    t.string "remember_token"
    t.integer "role", default: 0, null: false
    t.integer "sign_in_count", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.integer "stream_manager_id"
    t.string "uid", default: "", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_manager_id"], name: "index_people_on_chapter_manager_id"
    t.index ["email"], name: "index_people_on_email", unique: true
    t.index ["google_uid"], name: "index_people_on_google_uid", unique: true
    t.index ["provider", "uid"], name: "index_people_on_provider_and_uid", unique: true
    t.index ["stream_manager_id"], name: "index_people_on_stream_manager_id"
  end

  create_table "permission_caches", force: :cascade do |t|
    t.datetime "cached_at", null: false
    t.integer "permission", null: false
    t.integer "target_id", null: false
    t.integer "viewer_id", null: false
    t.index ["target_id"], name: "idx_permission_caches_target"
    t.index ["target_id"], name: "index_permission_caches_on_target_id"
    t.index ["viewer_id", "target_id", "permission"], name: "idx_permission_caches_unique", unique: true
    t.index ["viewer_id"], name: "index_permission_caches_on_viewer_id"
  end

  add_foreign_key "cycle_snapshots", "cycles"
  add_foreign_key "cycle_snapshots", "people"
  add_foreign_key "cycle_snapshots", "people", column: "chapter_manager_id"
  add_foreign_key "cycle_snapshots", "people", column: "stream_manager_id"
  add_foreign_key "evaluations", "cycles"
  add_foreign_key "evaluations", "people", column: "evaluated_id"
  add_foreign_key "evaluations", "people", column: "evaluator_id"
  add_foreign_key "people", "people", column: "chapter_manager_id"
  add_foreign_key "people", "people", column: "stream_manager_id"
  add_foreign_key "permission_caches", "people", column: "target_id"
  add_foreign_key "permission_caches", "people", column: "viewer_id"
end
