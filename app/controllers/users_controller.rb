require "http"

class UsersController < ApplicationController
  skip_before_action :authenticate, only: [:create_admin, :oauth_github, :oauth_google]

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

    if !response.status.success?
      return render status: :bad_request, json: {message: 'Invalid Github OAuth code'}
    end

    response = HTTP.headers(:accept => "application/json")
        .get("https://api.github.com/user?access_token=#{response.parse['access_token']}")

    if !response.status.success?
      return render status: :bad_request, json: {message: 'Error communicating with Github'}
    end

    parsed_response = response.parse

    github_id = parsed_response['id']
    github_name = parsed_response['name']

    u = User.find_or_create_by(github_id: github_id)
    if !u.persisted?
      u.name = github_name
      u.save!
    end
    jwt = Auth.issue({user_id: u.id})
    cookies['Authorization'] = {
      :value => jwt,
      :expires => 2.day.from_now
    }
    redirect_to "/"
  end

  def oauth_google()
    code = params[:code]
    validator = GoogleIDToken::Validator.new
    jwt = validator.check(code, google_client.id, google_client.id)
    if jwt
      google_id = jwt['sub']
      google_name = jwt['name']
      email = jwt['email']

      u = User.find_or_create_by(google_id: google_id)
      if !u.persisted?
        u.name = google_name
        u.email = email
        u.save!
      end
      jwt = Auth.issue({user_id: u.id})
      cookies['Authorization'] = {
        :value => jwt,
        :expires => 2.day.from_now
      }

      render status: :ok, json: u
    else
      logger.info validator.problem
      head :forbidden
    end
  end

  private
  def github_client
    OpenStruct.new Rails.application.secrets.github_client
  end

  def google_client
    OpenStruct.new Rails.application.secrets.google_client
  end
end
