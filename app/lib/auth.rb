# frozen_string_literal: true

require 'jwt'

class Auth
  HMAC_ALGORITHM = 'HS256'

  class << self
    def issue(payload)
      JWT.encode payload, jwt_secret, HMAC_ALGORITHM
    end

    def decode(token)
      JWT.decode(token, jwt_secret, true, algorithm: HMAC_ALGORITHM).first
    end

    private

    def jwt_secret
      Rails.application.secrets.jwt_secret
    end
  end
end
