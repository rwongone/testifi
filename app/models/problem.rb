class Problem < ApplicationRecord
  has_one :solution, class_name: "Submission", primary_key: "solution_id"
  has_many :submissions
  has_many :tests

  belongs_to :assignment

  delegate :course, :course_id, to: :assignment
end
