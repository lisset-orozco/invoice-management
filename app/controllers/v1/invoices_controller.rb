# frozen_string_literal: true

module V1
  class InvoicesController < ApplicationController
    def create
      response = Invoices::CreateService.call(invoice_params)
      default_response(response, :created)
    end

    def update
      response = Invoices::UpdateService.call(invoice_params)
      default_response(response, :ok)
    end

    private

    def default_response(response, status)
      if response.success?
        render(json: { data: response.payload }, status:)
      else
        render(json: { error: response.error }, status: :unprocessable_entity)
      end
    end

    def invoice_params
      params.permit(
        :user_id,
        :invoice_uuid,
        :status,
        :emitted_at,
        :expires_at,
        :signed_at,
        :cfdi_digital_stamp,
        emitter: %i[name rfc],
        receiver: %i[name rfc],
        amount: %i[cents currency]
      )
    end
  end
end
