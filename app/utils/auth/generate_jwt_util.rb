# frozen_string_literal: true

module Auth
  class GenerateJwtUtil < JwtBase
    def call
      raise(StandardError, 'Missing params') if params.blank?

      response(success: true, payload: generate_token)
    rescue => error
      response(error: { source: self.class.to_s, message: error.message })
    end

    private

    def generate_token
      params[:expires_in] = Integer(Time.zone.now + expiration)
      JWT.encode(params, JWT_SECRET, 'HS256')
    end

    def expiration
      params[:expires_in] || 24.hours.from_now
    end
  end
end
