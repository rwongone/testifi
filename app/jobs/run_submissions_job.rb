class RunSubmissionsJob < ApplicationJob
  queue_as :pending_execution

  def perform(*submission_ids)
    submissions = Submission.includes(:problem).find(submission_ids)
    submissions.each do |submission|
      submission.run_tests! if submission.id != submission.problem.solution_id
    end
  end
end
