class Course < ApplicationRecord
    has_and_belongs_to_many :students, class_name: "User", join_table: "courses_students", association_foreign_key: "student_id"
    belongs_to :teacher, class_name: "User", foreign_key: "teacher_id"
end
