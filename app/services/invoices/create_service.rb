# frozen_string_literal: true

module Invoices
  class CreateService < BaseService
    def initialize(params)
      super()

      @params = params
    end

    def call
      response(success: true, payload: create_invoice)
    rescue => error
      response(error: { source: self.class.to_s, message: error.message })
    end

    private

    attr_reader :params

    def create_invoice
      Invoice.create!(**build_params)
    end
  end
end
