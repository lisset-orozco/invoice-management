# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate

  def authenticate
    return render_unauthorized if request.headers['Authorization'].blank?

    response = Auth::ValidateJwtUtil.call(token: request.headers['Authorization'])
    raise(StandardError, response.error) unless response.success?

    params[:user_id] = response.payload['user_id']
  end

  def render_unauthorized
    render(status: :unauthorized)
  end

  rescue_from Exception do |exception|
    render json: { error: exception }, status: :unprocessable_entity
  end
end
