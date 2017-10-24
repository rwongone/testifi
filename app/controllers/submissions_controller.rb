# frozen_string_literal: true

require 'test_executor'
require 'file_helper'

class SubmissionsController < ApplicationController
  skip_before_action :check_admin

  def create
    problem = Problem.find(params[:problem_id])
    course = problem.course
    unless current_user_in_course?(course)
      head :forbidden
      return
    end

    uploaded_file = params[:file]

    submission_lang = FileHelper.filename_to_language(uploaded_file.original_filename)
    if submission_lang.nil?
      render status: :bad_request, json: { message: 'No file extension to infer submission language' }
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

      problem.update(solution_id: submission.id) if current_user.admin?
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
    unless current_user_in_course?(course)
      head :forbidden
      return
    end

    submissions = Submission.where(problem_id: params[:problem_id])
    submissions = submissions.where(user_id: current_user.id) if current_user.admin?
    render status: :ok, json: submissions
  end

  def exec
    submission = Submission.find(params[:id])
    result = submission.run_tests!
    render status: :ok, json: { 'result': result }
  end
end
