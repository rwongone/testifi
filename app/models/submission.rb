class Submission < ApplicationRecord
  has_one :db_file, as: :has_a_file
  belongs_to :problem
  belongs_to :user

  delegate :course, to: :problem
end
