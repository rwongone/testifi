require 'test_executor'
require 'file_helper'

class SubmissionsController < ApplicationController
  skip_before_action :check_admin

  def create
    problem = Problem.find(params[:problem_id])
    course = problem.course
    if !current_user_in_course?(course)
      head :forbidden
      return
    end

    uploaded_file = params[:file]

    submission_lang = FileHelper.filename_to_language(uploaded_file.original_filename)
    if submission_lang.nil?
      render status: :bad_request, json: {message: "No file extension to infer submission language"}
      return
    end

    submission = Submission.new(
      user_id: current_user.id,
      problem_id: problem.id,
      language: submission_lang
    )

    ActiveRecord::Base.transaction do
      file = DbFile.create(
        name: uploaded_file.original_filename,
        content_type: 'text/plain',
        contents: uploaded_file.read
      )

      submission.db_file_id = file.id
      submission.save!

      if current_user.admin?
        problem.update(solution_id: submission.id)
      end
    end

    RunSubmissionsJob.perform_later(submission.id)

    render status: :created, json: submission
  end

  def show
    submission = Submission.find(params[:id])
    if submission.user_id != current_user.id && !current_user.admin?
      head :forbidden
      return
    end
    render status: :ok, json: submission
  end

  def show_file
    submission = Submission.includes(:db_file).find(params[:submission_id])
    if submission.user_id != current_user.id && !current_user.admin?
      head :forbidden
      return
    end

    file = submission.db_file
    send_data(file.contents,
              filename: file.name,
              type: file.content_type)
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
    result = TestExecutor.run_tests(submission)
    render status: :ok, json: { 'result': result }
  end
end
