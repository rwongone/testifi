# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate

  def create
    u = User.find_by(email: auth_params[:email])
    if u&.authenticate(auth_params[:password])
      jwt = Auth.issue(user_id: u.id)
      render status: :ok, json: { jwt: jwt }
    else
      render status: 400, json: {}
    end
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
