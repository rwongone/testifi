class ExecutionsController < ApplicationController
  skip_before_action :check_admin

  def results
    submission = Submission.find(params[:submission_id])

    if submission.user_id != current_user.id && !current_user.admin?
      head :forbidden
      return
    end

    num_passed = 0
    failed_execution_ids = []

    executions = Execution.select(:test_id, :passed).where(submission_id: params[:submission_id])

    executions.each do |execution|
      if execution.passed?
        num_passed += 1
      else
        failed_execution_ids << execution.test_id
      end
    end

    failed_test_hints = []
    if failed_execution_ids.size > 0
      failed_test_hints = Test.find(failed_execution_ids).pluck(:hint)
    end

    render status: :ok, json: {
      total_tests: executions.size,
      num_passed: num_passed,
      failed_test_hints: failed_test_hints
    }
  end
end
