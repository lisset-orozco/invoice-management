# frozen_string_literal: true

module V1
  class InvoicesController < ApplicationController
    def create
      response = Invoices::CreateService.call(invoice_params)

      if response.success?
        render(json: { data: response.payload }, status: :created)
      else
        render(json: { error: response.error }, status: :unprocessable_entity)
      end
    end

    private

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
