require 'mimemagic'

class TestsController < ApplicationController
  def create
    course = Problem.find(params[:problem_id]).course
    if !current_user_in_course?(course)
      head :forbidden
      return
    end

    uploaded_file = params[:file]

    ActiveRecord::Base.transaction do
      file = DbFile.create(
        name: uploaded_file.original_filename,
        type: MimeMagic.by_magic(uploaded_file),
        contents: uploaded_file.read,
      )

      test = Test.create(
        :user_id => current_user.id,
        :name => params[:name],
        :hint => params[:hint],
        :problem_id => params[:problem_id],
        :db_file_id => file.id,
      )

      render status: :created, json: test
    end
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

  private

  def create_params
    params.permit(:problem_id, :hint)
  end
end
