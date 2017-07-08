class AssignmentsController < ApplicationController
  skip_before_action :check_admin, only: [:show]

  def index
    render status: :ok, json: Assignment.where(course_id: params[:course_id])
  end

  def create
    course = Course.find(params[:course_id])
    if course.teacher_id != current_user.id
      head :forbidden
      return
    end

    assignment = Assignment.new(create_params)
    if assignment.save!
      render status: :created, json: assignment
    end
  end

  def show
    assignment = Assignment.includes(:course).find(params[:id])
    if !assignment.course.user_ids.include?(current_user.id)
      head :forbidden
      return
    end

    render status: :ok, json: assignment
  end

  def update
    assignment = Assignment.includes(:course).find(params[:id])

    if assignment.course.teacher_id != current_user.id
      head :forbidden
      return
    end

    if assignment.update!(create_params)
      render status: :ok, json: assignment
    end
  end

  def destroy
    assignment = Assignment.includes(:course).find(params[:id])

    if assignment.course.teacher_id != current_user.id
      head :forbidden
      return
    end

    assignment.destroy
    head :no_content
  end

  private
  def create_params
    params.permit(:name, :description, :course_id)
  end
end
