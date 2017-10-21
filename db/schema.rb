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

ActiveRecord::Schema.define(version: 20170713142139) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pgcrypto"

  create_table "assignments", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_assignments_on_course_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "course_code"
    t.string "title"
    t.text "description"
    t.bigint "teacher_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["teacher_id"], name: "index_courses_on_teacher_id"
  end

  create_table "courses_students", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "student_id", null: false
    t.index ["course_id"], name: "index_courses_students_on_course_id"
    t.index ["student_id"], name: "index_courses_students_on_student_id"
  end

  create_table "db_files", force: :cascade do |t|
    t.string "name", null: false
    t.string "content_type"
    t.binary "contents", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "executions", force: :cascade do |t|
    t.binary "output"
    t.binary "std_error"
    t.integer "return_code"
    t.bigint "submission_id", null: false
    t.bigint "test_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["submission_id"], name: "index_executions_on_submission_id"
    t.index ["test_id"], name: "index_executions_on_test_id"
  end

  create_table "invites", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.bigint "inviter_id", null: false
    t.bigint "redeemer_id"
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_invites_on_course_id"
    t.index ["inviter_id"], name: "index_invites_on_inviter_id"
    t.index ["redeemer_id"], name: "index_invites_on_redeemer_id"
  end

  create_table "problems", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "assignment_id"
    t.bigint "solution_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignment_id"], name: "index_problems_on_assignment_id"
    t.index ["solution_id"], name: "index_problems_on_solution_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "problem_id", null: false
    t.string "language", null: false
    t.bigint "db_file_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["db_file_id"], name: "index_submissions_on_db_file_id"
    t.index ["problem_id"], name: "index_submissions_on_problem_id"
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "tests", force: :cascade do |t|
    t.string "name"
    t.string "hint"
    t.binary "expected_output"
    t.bigint "problem_id"
    t.bigint "user_id"
    t.bigint "db_file_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["db_file_id"], name: "index_tests_on_db_file_id"
    t.index ["problem_id"], name: "index_tests_on_problem_id"
    t.index ["user_id"], name: "index_tests_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.boolean "admin"
    t.string "github_id"
    t.string "google_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["github_id"], name: "index_users_on_github_id", unique: true
    t.index ["google_id"], name: "index_users_on_google_id", unique: true
  end

end
