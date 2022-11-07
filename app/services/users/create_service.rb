# frozen_string_literal: true

module Users
  class CreateService < ApplicationService
    def initialize(params)
      super()

      @params = params
    end

    def call
      response(success: true, payload: create_user)
    rescue => error
      response(error: { source: self.class.to_s, message: error.message })
    end

    private

    attr_reader :params

    def create_user
      User.create!(**build_params)
    end

    def build_params
      {
        password: params[:password],
        email: params[:email]&.downcase,
        rfc: params[:rfc]
      }
    end
  end
end
