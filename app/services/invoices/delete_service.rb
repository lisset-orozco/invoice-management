# frozen_string_literal: true

module Invoices
  class DeleteService < BaseService
    def initialize(params)
      super()

      @params = params
    end

    def call
      response(success: true, payload: update_invoice)
    rescue => error
      response(error: { source: self.class.to_s, message: error.message })
    end

    private

    attr_reader :params

    def invoice
      @invoice ||= Invoice.find_by!(status: 'active', invoice_uuid: params[:invoice_uuid], user_id: params[:user_id])
    rescue ActiveRecord::RecordNotFound
      raise(StandardError, 'Invoice not found')
    end

    def update_invoice
      invoice.update!(deleted_at: Time.now.utc, status: 'inactive')
      invoice
    end
  end
end
