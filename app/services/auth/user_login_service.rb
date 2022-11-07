# frozen_string_literal: true

module Auth
  class UserLoginService < ApplicationService
    def initialize(params)
      super()

      @params = params
    end

    def call
      raise(StandardError, 'Missing params') if params.blank?

      validate_user

      response(success: true, payload: token)
    rescue => error
      response(error: { source: self.class.to_s, message: error.message })
    end

    private

    attr_reader :params

    def user
      @user ||= User.find_by!(email: params[:email].downcase)
    end

    def validate_user
      raise unless user&.authenticate(params[:password])
    rescue
      raise(StandardError, 'Wrong credentials')
    end

    def token
      response = Auth::GenerateJwtUtil.call(user_id: user.id, email: user.email)
      raise unless response.success?

      { token: response.payload }
    end
  end
end
