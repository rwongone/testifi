class ProblemsController < ApplicationController
  def create
    problem = Problem.new(create_params)
    if problem.save!
      render status: :created, json: problem
    end
  end

  def show
    problem = Problem.find(params[:id])
    render status: :ok, json: problem
  end

  def update
    problem = Problem.find(params[:id])
    if problem.update!(create_params)
      render status: :ok, json: problem
    end
  end

  def destroy
    problem = Problem.find(params[:id])
    problem.destroy
    head :no_content
  end

  private

  def create_params
    params.permit(:name, :description, :assignment_id, :cmd)
  end
end
