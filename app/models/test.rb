# frozen_string_literal: true

class Test < ApplicationRecord
  has_one :db_file, foreign_key: 'id', primary_key: 'db_file_id'
  has_many :executions

  belongs_to :problem
  belongs_to :user

  def fill_expected_output!
    self.expected_output = problem.solution.run_test!(self)
    save!
  end
end
