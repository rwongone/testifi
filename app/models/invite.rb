class Invite < ApplicationRecord
  belongs_to :inviter, class_name: "User", foreign_key: "inviter_id"
  belongs_to :course, class_name: "Course", foreign_key: "course_id"
end
