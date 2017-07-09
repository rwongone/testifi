class ProblemsController < ApplicationController
  skip_before_action :check_admin, only: [:show, :index]

  def index
    course = Assignment.find(params[:assignment_id]).course
    if !current_user_in_course?(course)
      head :forbidden
      return
    end

    render status: :ok, json: Problem.where(assignment_id: params[:assignment_id])
  end

  def create
    problem = Problem.new(create_params)
    if problem.save!
      render status: :created, json: problem
    end
  end

  def show
    problem = Problem.find(params[:id])
    course = problem.course
    if !current_user_in_course?(course)
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

    if problem.update!(create_params)
      render status: :ok, json: problem
    end
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
    params.permit(:name, :description, :assignment_id, :cmd)
  end
end
