# frozen_string_literal: true

class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string :course_code
      t.string :title
      t.text :description
      t.bigint :teacher_id, null: false

      t.timestamps
    end
    add_index :courses, :teacher_id

    create_table :courses_students do |t|
      t.bigint :course_id, null: false
      t.bigint :student_id, null: false
      t.index :course_id
      t.index :student_id
    end
  end
end
