# frozen_string_literal: true

module Invoices
  class BaseService < ApplicationService
    def build_params
      base_params.merge(emitter, receiver, amount)
    end

    def base_params
      {
        invoice_uuid: params[:invoice_uuid],
        status: params[:status],
        emitted_at: params[:emitted_at],
        expires_at: params[:expires_at],
        signed_at: params[:signed_at],
        cfdi_digital_stamp: params[:cfdi_digital_stamp],
        user_id: params[:user_id]
      }
    end

    def emitter
      {
        emitter_name: params.dig(:emitter, :name),
        emitter_rfc: params.dig(:emitter, :rfc),
      }
    end

    def receiver
      {
        receiver_name: params.dig(:receiver, :name),
        receiver_rfc: params.dig(:receiver, :rfc)
      }
    end

    def amount
      {
        amount: params.dig(:amount, :cents),
        currency: params.dig(:amount, :currency)
      }
    end
  end
end
