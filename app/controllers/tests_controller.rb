class TestsController < ApplicationController
  skip_before_action :check_admin, except: [:index]

  def create
    problem = Problem.includes(assignment: :course).find(params[:problem_id])
    course = problem.course
    if !current_user_in_course?(course)
      head :forbidden
      return
    end

    uploaded_file = params[:file]

    test = Test.new(
      :user_id => current_user.id,
      :name => params[:name],
      :hint => params[:hint],
      :problem_id => params[:problem_id],
    )
    ActiveRecord::Base.transaction do
      file = DbFile.create(
        name: uploaded_file.original_filename,
        content_type: 'text/plain',
        contents: uploaded_file.read,
      )

      test.db_file_id = file.id
      test.save!
    end

    FillExpectedOutputJob.perform_later(test.id)

    # Rerun most recent submissions of each user on this new test case
    newest_submission_ids_by_user = problem.submissions.group(:user_id).maximum(:id).values
    newest_submission_ids_by_user.delete(problem.solution_id)
    if newest_submission_ids_by_user.size > 0
      RunSubmissionsJob.perform_later(*newest_submission_ids_by_user)
    end

    render status: :created, json: test
  end

  def show
    test = Test.find(params[:id])
    # TODO: Do we want admin to be able to view student's test cases
    if test.user_id != current_user.id
      head :forbidden
      return
    end
    render status: :ok, json: test
  end

  def show_file
    test = Test.includes(:db_file).find(params[:id])
    if test.user_id != current_user.id && !current_user.admin?
      head :forbidden
      return
    end

    file = test.db_file
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

    tests = []
    if current_user.admin?
      tests = Test.where(problem_id: params[:problem_id])
    else
      tests = Test.where(problem_id: params[:problem_id], user_id: current_user.id)
    end

    render status: :ok, json: tests
  end

  def destroy
    test = Test.find(params[:id])
    if test.user_id != current_user.id
      head :forbidden
      return
    end

    test.destroy
  end

  private

  def create_params
    params.permit(:problem_id, :hint)
  end
end
