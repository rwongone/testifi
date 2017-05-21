class UsersController < ApplicationController
  skip_before_action :authenticate, only: [:create]

  def create
    u = User.new(create_params)
    if u.save!
      head :created
    end
  end

  def show
    u = User.find(params[:id])
    render json: u
  end

  private
  def create_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
