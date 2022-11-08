# frozen_string_literal: true

module V1
  class AuthController < ApplicationController
    skip_before_action :authenticate, only: :login

    def login
      response = Auth::UserLoginService.call(user_params)

      if response.success?
        render(json: { data: response.payload }, status: :ok)
      else
        render(json: { error: response.error }, status: :unprocessable_entity)
      end
    end

    private

    def user_params
      params.permit(:email, :password)
    end
  end
end
