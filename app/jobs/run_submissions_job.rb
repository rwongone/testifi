class RunSubmissionsJob < ApplicationJob
  queue_as :pending_execution

  def perform(*submission_ids)
    submissions = Submission.find(submission_ids)
    submissions.each do |submission|
      run_submission submission
    end
  end

  def run_submission(submission)
    tests = Test.where(problem_id: submission.problem_id)

    tests.each do |test|
      execution = Execution.find_or_initialize_by(submission_id: submission.id, test_id: test.id)
      
      if execution.persisted?
        next if execution.updated_at >= test.updated_at
      end
      execution.output = TestExecutor.run_test(submission, test)

      execution.save!
    end

  end
end
