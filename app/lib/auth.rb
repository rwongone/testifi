require 'jwt'

class Auth
  HMAC_ALGORITHM = 'HS256'

  def self.issue(payload)
    JWT.encode payload, jwt_secret, HMAC_ALGORITHM
  end

  def self.decode(token)
    JWT.decode(token, jwt_secret, true, {algorithm: HMAC_ALGORITHM}).first
  end

  private
  def self.jwt_secret
    Rails.application.secrets.jwt_secret
  end
end