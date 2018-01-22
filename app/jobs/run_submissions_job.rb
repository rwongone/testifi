# frozen_string_literal: true

class RunSubmissionsJob < ApplicationJob
  queue_as :pending_execution

  def perform(*submission_ids)
    submissions = Submission.includes(:problem).find(submission_ids)

    run_solutions(submissions)

    submissions.each do |submission|
      submission.run_tests! if submission.id != submission.problem.solution_id
    end
  end

  def run_solutions(submissions)
    solution_ids = submissions.map { |s| s.problem.solution_id }
    solutions = Submission.find(solution_ids)

    solutions.each do |solution|
      solution.run_tests!
    end
  end
end
