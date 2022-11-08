# frozen_string_literal: true

module V1
  class UsersController < ApplicationController
    skip_before_action :authenticate, only: :create

    def create
      response = Users::CreateService.call(user_params)

      if response.success?
        render(json: { data: response.payload }, status: :created)
      else
        render(json: { error: response.error }, status: :unprocessable_entity)
      end
    end

    private

    def user_params
      params.permit(:email, :password, :rfc)
    end
  end
end
