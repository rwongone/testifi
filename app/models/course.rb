class Course < ApplicationRecord
  has_and_belongs_to_many :students, class_name: "User", join_table: "courses_students", association_foreign_key: "student_id"
  belongs_to :teacher, class_name: "User", foreign_key: "teacher_id"
  has_many :invites, foreign_key: "invite_id"

  has_many :assignments

  def user_ids
    Set.new(student_ids.push(teacher_id))
  end

  def users
    User.where(id: user_ids)
  end
end
