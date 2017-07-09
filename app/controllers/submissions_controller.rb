require 'submission_executor'
require 'mimemagic'

class SubmissionsController < ApplicationController
  skip_before_action :check_admin

  def create
    course = Problem.find(params[:problem_id]).course
    if !current_user_in_course?(course)
      head :forbidden
      return
    end

    file = params[:file]

    file = DbFile.new(
      name: file.original_filename,
      type: MimeMagic.by_magic(file),
      contents: file.read,
    )

    submission = Submission.new(create_params.merge(
      user_id: current_user.id,
      db_file: file,
    ))

    if submission.save!
      render status: :created, json: submission
    end
  end

  def show
    submission = Submission.find(params[:id])
    if submission.user_id != current_user.id && !current_user.admin?
      head :forbidden
      return
    end
    render status: :ok, json: submission
  end

  def index
    course = Problem.find(params[:problem_id]).course
    if !current_user_in_course?(course)
      head :forbidden
      return
    end

    submissions = []
    if current_user.admin?
      submissions = Submission.where(problem_id: params[:problem_id])
    else
      submissions = Submission.where(problem_id: params[:problem_id], user_id: current_user.id)
    end

    render status: :ok, json: submissions
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
