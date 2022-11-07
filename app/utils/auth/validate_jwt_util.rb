# frozen_string_literal: true

module Auth
  class ValidateJwtUtil < JwtBase
    def call
      raise(StandardError, 'Missing params') if params.blank?
      raise(StandardError, 'Token is expired') unless valid_token?

      response(success: true, payload: token)
    rescue => error
      response(error: { source: self.class.to_s, message: error.message })
    end

    private

    def valid_token?
      Time.zone.now.to_i < token['expires_in']
    end

    def token
      @token ||=
        begin
          token_auth = params[:token].gsub(/^Bearer /, '')
          JWT.decode(token_auth, JWT_SECRET, true, { algorithm: ALGORITHM }).first
        end
    end
  end
end
