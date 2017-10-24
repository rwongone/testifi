# frozen_string_literal: true

class AssignmentsController < ApplicationController
  skip_before_action :check_admin, only: %i[show index]

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
    render status: :created, json: assignment if assignment.save!
  end

  def show
    assignment = Assignment.includes(:course).find(params[:id])
    unless current_user_in_course?(assignment.course)
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

    render status: :ok, json: assignment if assignment.update!(create_params)
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
