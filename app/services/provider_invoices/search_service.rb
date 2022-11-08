# frozen_string_literal: true

module ProviderInvoices
  class SearchService < ApplicationService
    def initialize(params)
      super()

      @params = params
    end

    def call
      response(success: true, payload: invoices)
    rescue => error
      response(error: { source: self.class.to_s, message: error.message })
    end

    private

    attr_reader :params

    def receiver_rfc
      User.find_by(id: params[:user_id]).rfc
    end

    def invoices
      Invoice
        .with_emitted_at(params[:emitted_at])
        .where(receiver_rfc:, deleted_at: nil).page(params[:page_number]).per(params[:page_size])
    end
  end
end
