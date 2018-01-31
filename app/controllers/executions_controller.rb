# frozen_string_literal: true

class ExecutionsController < ApplicationController
  skip_before_action :check_admin

  def results
    submission = Submission.find(params[:submission_id])

    if submission.user_id != current_user.id && !current_user.admin?
      head :forbidden
      return
    end

    total_tests = submission.problem.tests.count

    executions = Execution.where(submission: submission)
    executions_passed = executions.select(&:passed?)
    executions_failed = executions.select(&:failed?)
    executions_errored = executions.select(&:errored?)

    failed_test_hints = Test.find(executions_failed.map(&:test_id)).pluck(:hint)

    render status: :ok, json: {
      executions: {
        passed: executions_passed,
        failed: executions_failed,
        errored: executions_errored,
      },
      total_tests: total_tests,
      pending_tests: total_tests - executions.size,
      tests_executed: executions.size,
      num_passed: executions_passed.size,
      failed_test_hints: failed_test_hints,
    }
  end
end
