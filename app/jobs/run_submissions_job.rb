class RunSubmissionsJob < ApplicationJob
  queue_as :pending_execution

  def perform(*submission_ids)
    submissions = Submission.includes(:problem).find(submission_ids)
    submissions.each do |submission|
      run_submission submission if submission.id != submission.problem.solution_id
    end
  end

  def run_submission(submission)
    tests = Test.where(problem_id: submission.problem_id)

    tests.each do |test|
      execution = Execution.find_or_initialize_by(submission_id: submission.id, test_id: test.id)
      
      next if execution.persisted? && execution.updated_at >= test.updated_at
      execution.output = TestExecutor.run_test(submission, test)
      execution.passed = test.expected_output == execution.output

      execution.save!
    end

  end
end
