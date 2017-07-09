class ApplicationController < ActionController::API
  include ActionController::Cookies

  before_action :authenticate, :check_admin

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

  def check_admin
    head :forbidden if !current_user.admin?
  end

  def current_user_in_course?(course)
    course.user_ids.include? current_user.id
  end

  private

  def auth
    Auth.decode(bearer_token)
  end

  def bearer_token
    cookies['Authorization']
  end

  def bearer_token?
    !bearer_token.nil?
  end
end
