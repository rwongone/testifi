class AssignmentsController < ApplicationController
  def create
    assignment = Assignment.new(create_params)
    if assignment.save!
      render status: :created, json: assignment
    end
  end

  def show
    assignment = Assignment.find(params[:id])
    render status: :ok, json: assignment
  end

  def update
    assignmnent = Assignment.find(params[:id])
    if assignment.update!(create_params)
      render status: :ok, json: assignment
    end
  end

  def destroy
    assignment = Assignment.find(params[:id])
    assignment.destroy
    head :no_content
  end

  private

  def create_params
    params.permit(:name, :description, :course_id)
  end
end
