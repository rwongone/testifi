class UsersController < ApplicationController
  skip_before_action :authenticate, only: [:create, :create_admin]

  def create_admin
    u = User.where(admin: true).first
    if !u
      u = User.new(create_params.merge(admin: true))
      if u.save!
        render status: :created, json: u
      end
    else
      head 400
    end
  end

  def create
    u = User.new(create_params)
    if u.save!
      render status: :created, json: u
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
