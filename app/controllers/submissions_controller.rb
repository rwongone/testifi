require 'submission_executor'

class SubmissionsController < ApplicationController
  def create
    submission = Submission.new(create_params)
    if submission.save!
      render status: :created, json: submission
    end
  end

  def show
    submission = Submission.find(params[:id])
    render status: :ok, json: submission
  end

  def update
    submission = Submission.find(params[:id])
    if submission.update!(create_params)
      render status: :ok, json: submission
    end
  end

  def destroy
    submission = Submission.find(params[:id])
    submission.destroy
    head :no_content
  end

  def exec
    submission = Submission.find(params[:id])
    result = SubmissionExecutor.run_tests(submission)
    render status: :ok, json: { 'result': result }
  end

  private

  def create_params
    params.permit(:user_id, :problem_id, :language, :filepath)
  end
end
