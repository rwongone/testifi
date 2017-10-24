# frozen_string_literal: true

require 'http'

class UsersController < ApplicationController
  skip_before_action :authenticate, only: %i[create_admin oauth_github oauth_google logout]
  skip_before_action :check_admin

  def create_admin
    u = User.where(admin: true).first
    if !u
      u = User.new(create_params.merge(admin: true))
      if u.save!
        jwt = Auth.issue(user_id: u.id)
        cookies['Authorization'] = {
          value: jwt,
          expires: 2.day.from_now
        }
        render status: :created, json: u
      end
    else
      head 400
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

  def oauth_github
    code = params[:code]
    data = {
      client_id: github_client.id,
      client_secret: github_client.secret,
      code: code
    }

    response = HTTP.headers(accept: 'application/json')
                   .post('https://github.com/login/oauth/access_token?', json: data)

    unless response.status.success?
      return render status: :bad_request, json: { message: 'Invalid Github OAuth code' }
    end

    response = HTTP.headers(accept: 'application/json')
                   .get("https://api.github.com/user?access_token=#{response.parse['access_token']}")

    unless response.status.success?
      return render status: :bad_request, json: { message: 'Error communicating with Github' }
    end

    parsed_response = response.parse

    github_id = parsed_response['id']
    github_name = parsed_response['name']

    user = User.find_or_create_by(github_id: github_id) do |u|
      u.admin = !admin_exists
      u.name = github_name
      u.save!
    end
    jwt = Auth.issue(user_id: user.id)
    cookies['Authorization'] = {
      value: jwt,
      expires: 2.day.from_now
    }
    redirect_to '/'
  end

  def oauth_google
    code = params[:code]
    validator = GoogleIDToken::Validator.new
    google_jwt = validator.check(code, google_client.id, google_client.id)
    if google_jwt
      google_id = google_jwt['sub']
      google_name = google_jwt['name']
      email = google_jwt['email']

      user = User.find_or_create_by(google_id: google_id) do |u|
        u.admin = !admin_exists
        u.name = google_name
        u.email = email
        u.save!
      end
      jwt = Auth.issue(user_id: user.id)
      cookies['Authorization'] = {
        value: jwt,
        expires: 2.day.from_now
      }

      render status: :ok, json: user
    else
      logger.info validator.problem
      head :forbidden
    end
  end

  def logout
    cookies.delete 'Authorization'
    head :ok
  end

  private

  def github_client
    OpenStruct.new Rails.application.secrets.github_client
  end

  def google_client
    OpenStruct.new Rails.application.secrets.google_client
  end

  def admin_exists
    User.exists?(admin: true)
  end
end
