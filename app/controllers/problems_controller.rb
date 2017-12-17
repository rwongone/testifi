# frozen_string_literal: true

class ProblemsController < ApplicationController
  skip_before_action :check_admin, only: %i[show index]

  def index
    course = Assignment.find(params[:assignment_id]).course
    unless current_user_in_course?(course)
      head :forbidden
      return
    end

    render status: :ok, json: Problem.where(assignment_id: params[:assignment_id])
  end

  def show_solution_file
    problem = Problem.find(params[:problem_id])
    if problem.course.teacher_id != current_user.id || !current_user.admin?
      head :forbidden
      return
    end

    file = problem.solution.db_file
    send_data(file.contents,
              filename: file.name,
              type: file.content_type)
  end

  def create
    problem = Problem.create!(create_params)

    uploaded_file = params[:file]
    if uploaded_file.present?
      ActiveRecord::Base.transaction do
        file = DbFile.create(
          name: uploaded_file.original_filename,
          content_type: 'text/plain',
          contents: uploaded_file.read
        )

        solution = Submission.create(
          user: current_user,
          problem: problem,
          db_file_id: file.id,
          language: FileHelper.filename_to_language(uploaded_file.original_filename)
        )

        problem.solution_id = solution.id
      end
      problem.save!
    end

    render status: :created, json: problem
  end

  def show
    problem = Problem.find(params[:id])
    course = problem.course
    unless current_user_in_course?(course)
      head :forbidden
      return
    end

    render status: :ok, json: problem
  end

  def update
    problem = Problem.find(params[:id])

    course = problem.course
    if course.teacher_id != current_user.id
      head :forbidden
      return
    end

    render status: :ok, json: problem if problem.update!(create_params)
  end

  def destroy
    problem = Problem.find(params[:id])

    course = problem.course
    if course.teacher_id != current_user.id
      head :forbidden
      return
    end

    problem.destroy
    head :no_content
  end

  private

  def create_params
    params.permit(:name, :description, :assignment_id)
  end
end
