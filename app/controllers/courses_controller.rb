# frozen_string_literal: true

class CoursesController < ApplicationController
  skip_before_action :check_admin, only: [:visible]

  def create
    course = Course.new(create_params)
    course.teacher_id = current_user.id
    render status: :created, json: course if course.save!
  end

  def update
    # cannot update someone else's course
    course = Course.find(params[:id])
    if course.teacher_id != current_user.id
      head :forbidden
      return
    end

    render status: :ok, json: course if course.update!(create_params)
  end

  def destroy
    # cannot delete someone else's course
    course = Course.find(params[:id])
    if course.teacher_id != current_user.id
      head :forbidden
      return
    end

    course.destroy
    head :no_content
  end

  # get visible returns courses that are taught by an admin or enrolled in by a student
  def visible
    if current_user.admin?
      render status: :ok, json: current_user.taught_courses
    else
      render status: :ok, json: current_user.enrolled_courses
    end
  end

  def students
    stds = Course.find(params[:course_id]).students
    render status: :ok, json: stds
  end

  private

  def create_params
    params.permit(:course_code, :title, :description)
  end
end
