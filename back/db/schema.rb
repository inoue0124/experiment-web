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

ActiveRecord::Schema.define(version: 2021_04_25_173133) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "d_assessments", force: :cascade do |t|
    t.bigint "t_assessment_id"
    t.bigint "t_user_id"
    t.integer "file_number"
    t.integer "score"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reason_first"
    t.string "reason_second"
    t.index ["t_assessment_id"], name: "index_d_assessments_on_t_assessment_id"
    t.index ["t_user_id"], name: "index_d_assessments_on_t_user_id"
  end

  create_table "d_facesheets", force: :cascade do |t|
    t.bigint "t_user_id"
    t.bigint "t_facesheet_id"
    t.string "name"
    t.string "email"
    t.integer "gender"
    t.integer "age"
    t.integer "is_student"
    t.integer "department_type"
    t.string "department_name"
    t.integer "is_opi"
    t.integer "is_teacher"
    t.integer "teaching_years"
    t.integer "teach_speaking_experience"
    t.integer "teach_speaking_years"
    t.integer "is_japan"
    t.string "country_name"
    t.integer "institute"
    t.string "other_institute"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["t_facesheet_id"], name: "index_d_facesheets_on_t_facesheet_id"
    t.index ["t_user_id"], name: "index_d_facesheets_on_t_user_id"
  end

  create_table "d_transfers", force: :cascade do |t|
    t.bigint "t_user_id"
    t.string "excel_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["t_user_id"], name: "index_d_transfers_on_t_user_id"
  end

  create_table "m_works", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "t_agreements", force: :cascade do |t|
    t.bigint "t_workflow_id"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["t_workflow_id"], name: "index_t_agreements_on_t_workflow_id"
  end

  create_table "t_assessments", force: :cascade do |t|
    t.bigint "t_workflow_id"
    t.boolean "is_practice"
    t.integer "point"
    t.integer "num_files"
    t.string "criteria"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reasons"
    t.boolean "is_second_time"
    t.index ["t_workflow_id"], name: "index_t_assessments_on_t_workflow_id"
  end

  create_table "t_experiments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "t_facesheets", force: :cascade do |t|
    t.bigint "t_workflow_id"
    t.boolean "name"
    t.boolean "email"
    t.boolean "gender"
    t.boolean "age"
    t.boolean "is_student"
    t.boolean "department"
    t.boolean "is_opi"
    t.boolean "is_teacher"
    t.boolean "teach_speaking_experience"
    t.boolean "country"
    t.boolean "institute"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["t_workflow_id"], name: "index_t_facesheets_on_t_workflow_id"
  end

  create_table "t_questionnaires", force: :cascade do |t|
    t.bigint "t_workflow_id"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["t_workflow_id"], name: "index_t_questionnaires_on_t_workflow_id"
  end

  create_table "t_transfers", force: :cascade do |t|
    t.bigint "t_workflow_id"
    t.boolean "is_second_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["t_workflow_id"], name: "index_t_transfers_on_t_workflow_id"
  end

  create_table "t_users", force: :cascade do |t|
    t.string "uuid"
    t.string "email"
    t.string "password_digest"
    t.integer "user_type"
    t.integer "t_experiment_id"
    t.integer "done_workflow_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "t_workflows", force: :cascade do |t|
    t.bigint "t_experiment_id"
    t.bigint "m_work_id"
    t.integer "next_workflow_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["m_work_id"], name: "index_t_workflows_on_m_work_id"
    t.index ["t_experiment_id"], name: "index_t_workflows_on_t_experiment_id"
  end

  add_foreign_key "d_assessments", "t_assessments"
  add_foreign_key "d_assessments", "t_users"
  add_foreign_key "d_facesheets", "t_facesheets"
  add_foreign_key "d_facesheets", "t_users"
  add_foreign_key "d_transfers", "t_users"
  add_foreign_key "t_agreements", "t_workflows"
  add_foreign_key "t_assessments", "t_workflows"
  add_foreign_key "t_facesheets", "t_workflows"
  add_foreign_key "t_questionnaires", "t_workflows"
  add_foreign_key "t_transfers", "t_workflows"
  add_foreign_key "t_workflows", "m_works"
  add_foreign_key "t_workflows", "t_experiments"
end
