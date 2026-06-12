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

ActiveRecord::Schema[8.1].define(version: 2026_06_11_203335) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
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

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "answers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "evaluation_id", null: false
    t.decimal "numeric_value", precision: 5, scale: 2
    t.integer "question_id", null: false
    t.text "text_value"
    t.datetime "updated_at", null: false
    t.index ["evaluation_id", "question_id"], name: "index_answers_on_evaluation_id_and_question_id", unique: true
    t.index ["evaluation_id"], name: "index_answers_on_evaluation_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "cargos", force: :cascade do |t|
    t.boolean "active"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "level"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "cycle_evaluation_plans", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "cycle_id", null: false
    t.integer "evaluated_id", null: false
    t.integer "evaluation_type", default: 0, null: false
    t.integer "evaluator_id", null: false
    t.integer "origin", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["cycle_id", "evaluator_id", "evaluated_id"], name: "idx_eval_plan_unique", unique: true
    t.index ["cycle_id"], name: "index_cycle_evaluation_plans_on_cycle_id"
    t.index ["evaluated_id"], name: "index_cycle_evaluation_plans_on_evaluated_id"
    t.index ["evaluator_id"], name: "index_cycle_evaluation_plans_on_evaluator_id"
  end

  create_table "cycle_participants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "cycle_id", null: false
    t.integer "person_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["cycle_id", "person_id"], name: "index_cycle_participants_on_cycle_id_and_person_id", unique: true
    t.index ["cycle_id"], name: "index_cycle_participants_on_cycle_id"
  end

  create_table "cycle_results", force: :cascade do |t|
    t.datetime "calibrated_at"
    t.integer "calibrated_by_id"
    t.text "calibration_notes"
    t.datetime "created_at", null: false
    t.integer "cycle_id", null: false
    t.boolean "is_calibrated", default: false
    t.integer "nine_box_position"
    t.float "performance_score"
    t.integer "person_id", null: false
    t.float "potential_score"
    t.float "pre_calibration_performance"
    t.integer "pre_calibration_position"
    t.float "pre_calibration_potential"
    t.datetime "updated_at", null: false
    t.index ["cycle_id", "person_id"], name: "index_cycle_results_on_cycle_id_and_person_id", unique: true
    t.index ["cycle_id"], name: "index_cycle_results_on_cycle_id"
    t.index ["person_id"], name: "index_cycle_results_on_person_id"
  end

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
    t.datetime "calibration_end"
    t.datetime "calibration_start"
    t.datetime "closed_at"
    t.datetime "created_at", null: false
    t.integer "created_by_id"
    t.text "description"
    t.date "evaluation_deadline"
    t.datetime "evaluation_end"
    t.datetime "evaluation_start"
    t.integer "max_peer_nominations", default: 5, null: false
    t.string "name", null: false
    t.json "nine_box_config", default: {}, null: false
    t.datetime "nominations_end"
    t.datetime "nominations_start"
    t.datetime "opened_at"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.datetime "validations_end"
    t.datetime "validations_start"
    t.index ["status"], name: "index_cycles_on_status"
  end

  create_table "evaluations", force: :cascade do |t|
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.integer "cycle_id", null: false
    t.integer "evaluated_id", null: false
    t.integer "evaluation_type", default: 0, null: false
    t.integer "evaluator_id", null: false
    t.text "improvements"
    t.integer "nomination_id"
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

  create_table "feedbacks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "cycle_id"
    t.integer "giver_id", null: false
    t.text "message", null: false
    t.integer "receiver_id", null: false
    t.datetime "updated_at", null: false
    t.integer "visibility", default: 0, null: false
    t.index ["cycle_id"], name: "index_feedbacks_on_cycle_id"
    t.index ["giver_id"], name: "index_feedbacks_on_giver_id"
    t.index ["receiver_id"], name: "index_feedbacks_on_receiver_id"
    t.index ["visibility"], name: "index_feedbacks_on_visibility"
  end

  create_table "nominations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "cycle_id", null: false
    t.integer "evaluated_id", null: false
    t.integer "nominee_id", null: false
    t.text "rejection_reason"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.datetime "validated_at"
    t.integer "validated_by_id"
    t.index ["cycle_id", "evaluated_id", "nominee_id"], name: "index_nominations_on_cycle_id_and_evaluated_id_and_nominee_id", unique: true
    t.index ["cycle_id"], name: "index_nominations_on_cycle_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "link"
    t.integer "person_id", null: false
    t.datetime "read_at"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id", "read_at"], name: "index_notifications_on_person_id_and_read_at"
    t.index ["person_id"], name: "index_notifications_on_person_id"
  end

  create_table "pdis", force: :cascade do |t|
    t.json "actions", default: [], null: false
    t.datetime "created_at", null: false
    t.integer "cycle_id"
    t.text "description"
    t.date "due_date"
    t.integer "person_id", null: false
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["cycle_id"], name: "index_pdis_on_cycle_id"
    t.index ["person_id"], name: "index_pdis_on_person_id"
    t.index ["status"], name: "index_pdis_on_status"
  end

  create_table "people", force: :cascade do |t|
    t.integer "chapter_manager_id"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", null: false
    t.string "google_uid"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "name", null: false
    t.date "offboarded_at"
    t.datetime "org_updated_at"
    t.string "provider"
    t.datetime "remember_created_at"
    t.string "remember_token"
    t.integer "role", default: 0, null: false
    t.integer "sign_in_count", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.integer "stream_manager_id"
    t.string "uid"
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

  create_table "questions", force: :cascade do |t|
    t.integer "answer_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.integer "cycle_id", null: false
    t.string "dimension", null: false
    t.string "evaluator_types", default: "all"
    t.integer "max_score", default: 10
    t.integer "min_score", default: 1
    t.integer "position", default: 0
    t.text "text", null: false
    t.datetime "updated_at", null: false
    t.decimal "weight", precision: 4, scale: 2, default: "1.0"
    t.index ["cycle_id"], name: "index_questions_on_cycle_id"
  end

  create_table "recovery_plans", force: :cascade do |t|
    t.json "actions"
    t.datetime "created_at", null: false
    t.integer "created_by_id"
    t.integer "cycle_id"
    t.text "description"
    t.date "due_date"
    t.text "outcome"
    t.integer "person_id", null: false
    t.text "reason"
    t.integer "status"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["cycle_id"], name: "index_recovery_plans_on_cycle_id"
    t.index ["person_id"], name: "index_recovery_plans_on_person_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "evaluations"
  add_foreign_key "answers", "questions"
  add_foreign_key "cycle_evaluation_plans", "cycles"
  add_foreign_key "cycle_evaluation_plans", "people", column: "evaluated_id"
  add_foreign_key "cycle_evaluation_plans", "people", column: "evaluator_id"
  add_foreign_key "cycle_participants", "cycles"
  add_foreign_key "cycle_results", "cycles"
  add_foreign_key "cycle_results", "people"
  add_foreign_key "cycle_snapshots", "cycles"
  add_foreign_key "cycle_snapshots", "people"
  add_foreign_key "cycle_snapshots", "people", column: "chapter_manager_id"
  add_foreign_key "cycle_snapshots", "people", column: "stream_manager_id"
  add_foreign_key "evaluations", "cycles"
  add_foreign_key "evaluations", "people", column: "evaluated_id"
  add_foreign_key "evaluations", "people", column: "evaluator_id"
  add_foreign_key "feedbacks", "cycles"
  add_foreign_key "feedbacks", "people", column: "giver_id"
  add_foreign_key "feedbacks", "people", column: "receiver_id"
  add_foreign_key "nominations", "cycles"
  add_foreign_key "notifications", "people"
  add_foreign_key "pdis", "cycles"
  add_foreign_key "pdis", "people"
  add_foreign_key "people", "people", column: "chapter_manager_id"
  add_foreign_key "people", "people", column: "stream_manager_id"
  add_foreign_key "permission_caches", "people", column: "target_id"
  add_foreign_key "permission_caches", "people", column: "viewer_id"
  add_foreign_key "questions", "cycles"
  add_foreign_key "recovery_plans", "cycles"
  add_foreign_key "recovery_plans", "people"
end
