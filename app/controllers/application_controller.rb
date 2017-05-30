class ApplicationController < ActionController::API
  before_action :authenticate

  def logged_in?
    !!current_user
  end

  def current_user
    if bearer_token?
      user_id = auth["user_id"]
      user = User.find_by(id: user_id)
      @current_user ||= user
    end
  end

  def authenticate
    head :unauthorized if !logged_in?
  end

  private

  def auth
    Auth.decode(bearer_token)
  end

  def bearer_token
    request.env['HTTP_AUTHORIZATION'].scan(/Bearer (.*)$/).flatten.last
  end

  def bearer_token?
    !!request.env.fetch('HTTP_AUTHORIZATION', "").scan(/Bearer/).flatten.first
  end
end
