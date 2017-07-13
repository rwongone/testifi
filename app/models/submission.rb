class Submission < ApplicationRecord
  has_one :db_file, foreign_key: "id", primary_key: "db_file_id"
  has_one :execution

  belongs_to :problem
  belongs_to :user

  delegate :course, to: :problem
end
