class CoursesController < ApplicationController
  def create
    course = Course.new(create_params)
    if course.save!
      render status: :created, json: course
    end
  end

  def show
    course = Course.find(params[:id])
    render status: :ok, json: course
  end

  def update
    course = Course.find(params[:id])
    if course.update!(create_params)
      render status: :ok, json: course
    end
  end

  def destroy
    course = Course.find(params[:id])
    course.destroy
    head :no_content
  end

  def get_enrolled
    render status: :ok, json: current_user.enrolled_courses
  end

  private

  def create_params
    params.permit(:course_code, :title, :description)
  end
end
