class SubmissionsController < ApplicationController
  def create
    problem = Submission.new(create_params)
    if problem.save!
      render status: :created, json: problem
    end
  end

  def show
    problem = Submission.find(params[:id])
    render status: :ok, json: problem
  end

  def update
    problem = Submission.find(params[:id])
    if problem.update!(create_params)
      render status: :ok, json: problem
    end
  end

  def destroy
    problem = Submission.find(params[:id])
    problem.destroy
    head :no_content
  end

  private

  def create_params
    params.permit(:user_id, :problem_id, :language, :filepath)
  end
end
