class Assignment < ApplicationRecord
  has_many :problems

  belongs_to :course
end
