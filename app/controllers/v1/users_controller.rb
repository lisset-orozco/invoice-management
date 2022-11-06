# frozen_string_literal: true

module V1
  class UsersController < ApplicationController
    def create
      @user = User.new(user_params)

      if @user.save
        render(json: @user, status: :created)
      else
        render(json: @user.errors, status: :unprocessable_entity)
      end
    end

    private

    def user_params
      params.permit(:email, :password, :rfc)
    end
  end
end
