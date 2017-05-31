require "http"

class UsersController < ApplicationController
  skip_before_action :authenticate, only: [:create, :create_admin, :oauth_github]

  def create_admin
    u = User.where(admin: true).first
    if !u
      u = User.new(create_params.merge(admin: true))
      if u.save!
        jwt = Auth.issue({user_id: u.id})
        cookies['Authorization'] = {
          :value => jwt,
          :expires => 2.day.from_now
        }
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

  # Returns current user if there is one
  def current
    render status: :ok, json: current_user
  end

  def oauth_github()
    code = params[:code]
    data = {
      client_id: github_client.id,
      client_secret: github_client.secret,
      code: code
    }

    response = HTTP.headers(:accept => "application/json")
        .post("https://github.com/login/oauth/access_token?", json: data)
        .parse
    response = HTTP.headers(:accept => "application/json")
        .get("https://api.github.com/user?access_token=#{response['access_token']}")
        .parse

    github_id = response['id']
    github_name = response['name']

    u = User.find_or_create_by(github_id: github_id)
    if !u.persisted?
      u.name = github_name
      u.password = SecureRandom.hex
      u.save!
    end
    jwt = Auth.issue({user_id: u.id})
    cookies['Authorization'] = {
      :value => jwt,
      :expires => 2.day.from_now
    }
    redirect_to "/"
  end

  private
  def create_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

  def github_client
    OpenStruct.new Rails.application.secrets.github_client
  end
end
