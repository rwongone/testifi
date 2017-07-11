class Test < ApplicationRecord
  has_one :db_file, foreign_key: "id", primary_key: "db_file_id"
  belongs_to :problem
  belongs_to :user
end
