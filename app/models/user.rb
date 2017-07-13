class User < ApplicationRecord
  has_and_belongs_to_many :enrolled_courses, class_name: "Course", join_table: "courses_students", foreign_key: "student_id"
  has_many :taught_courses, class_name: "Course", foreign_key: "teacher_id"
  has_many :invites, foreign_key: "inviter_id"

  has_many :submissions
  has_many :tests
end
