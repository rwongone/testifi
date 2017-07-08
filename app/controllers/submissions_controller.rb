require 'submission_executor'
require 'mimemagic'

class SubmissionsController < ApplicationController
  skip_before_action :check_admin

  def create
    file = params[:file]
    content_type = MimeMagic.by_magic(file)
    filename = file.original_filename
    file_contents = file.read

    submission = Submission.new(create_params.merge(
        content_type: content_type,
        filename: filename,
        file_contents: file_contents))
    if submission.save!
      render status: :created, json: submission
    end
  end

  def show
    submission = Submission.find(params[:id])
    render status: :ok, json: submission
  end

  def index
    submissions = Submission.all
    render status: :ok, json: submissions
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
    params.permit(:user_id, :problem_id, :language)
  end
end
