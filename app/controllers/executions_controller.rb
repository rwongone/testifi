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

    executions = Execution.includes(:test).where(submission: submission).map do |ex|
      ex.attributes.merge({
        status: ex.status,
        hint: ex.test.hint,
        test_name: ex.test.name,
      })
    end

    render status: :ok, json: {
      executions: executions,
      total_tests: total_tests,
    }
  end
end
