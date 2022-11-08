# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate

  rescue_from Exception do |exception|
    render json: { error: exception }, status: :unprocessable_entity
  end

  def authenticate
    return render_unauthorized if request.headers['Authorization'].blank?

    response = Auth::ValidateJwtUtil.call(token: request.headers['Authorization'])
    raise(StandardError, response.error) unless response.success?

    params[:user_id] = response.payload['user_id']
  end

  def render_unauthorized
    render(status: :unauthorized)
  end

  def paginate(collection, total_amount = nil)
    filter = { pages: collection.total_pages, page_number: collection.current_page, page_size: collection.size }

    filter[:total_amount] = collection.pluck(:amount).sum if total_amount
    filter[:invoices] = collection
    filter
  end
end
