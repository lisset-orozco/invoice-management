# frozen_string_literal: true

module V1
  class ProviderInvoicesController < ApplicationController
    def index
      response = ProviderInvoices::SearchService.call(search_params)

      if response.success?
        render(json: { data: paginate(response.payload, true) })
      else
        render(json: { error: response.error }, status: :unprocessable_entity)
      end
    end

    private

    def search_params
      params.permit(:user_id, :emitted_at, :page_number, :page_size)
    end
  end
end
