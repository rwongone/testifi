class Submission < ApplicationRecord
  belongs_to :problem, optional: true
  belongs_to :user, optional: true
end
