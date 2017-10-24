# frozen_string_literal: true

class Submission < ApplicationRecord
  has_one :db_file, foreign_key: 'id', primary_key: 'db_file_id'
  has_many :executions

  belongs_to :problem
  belongs_to :user

  delegate :course, to: :problem

  def correct?
    Test.where(problem: problem).all? do |test|
      execution = if tests_executed.include?(test)
                    Execution.find_by(submission: self, test: test)
                  else
                    run_test!(test, false)
                  end
      execution.passed?
    end
  end

  def run_test!(test, output_only = true)
    execution = Execution.find_or_initialize_by(submission: self, test: test)

    unless execution.persisted? && execution.updated_at >= test.updated_at
      execution.output, execution.std_error, execution.return_code = TestExecutor.run_test(self, test)
      execution.save!
    end

    output_only ? execution.output : execution
  end

  def run_tests!
    Test.where(problem: problem).each do |test|
      run_test!(test)
    end
  end

  def tests_executed
    executions.map(&:test)
  end
end
