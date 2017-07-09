class Submission < ApplicationRecord
  belongs_to :problem
  belongs_to :user

  delegate :course, to: :problem
end
