class Problem < ApplicationRecord
  has_many :submissions
  has_many :tests

  belongs_to :assignment
end
