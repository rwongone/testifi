# frozen_string_literal: true

class ExecutionsController < ApplicationController
  skip_before_action :check_admin

  def results
    submission = Submission.find(params[:submission_id])

    if submission.user_id != current_user.id && !current_user.admin?
      head :forbidden
      return
    end

    executions = Execution.where(submission: submission)
    failed_test_ids = executions
                      .reject(&:passed?)
                      .map(&:test_id)

    num_passed = executions.size - failed_test_ids.size

    failed_test_hints = []
    unless failed_test_ids.empty?
      failed_test_hints = Test.find(failed_test_ids).pluck(:hint)
    end

    render status: :ok, json: {
      total_tests: executions.size,
      num_passed: num_passed,
      failed_test_hints: failed_test_hints
    }
  end
end
