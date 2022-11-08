# frozen_string_literal: true

module Invoices
  class BuildService < BaseService
    def initialize(params)
      super()

      @params = params
    end

    def call
      response(success: true, payload: build_invoice)
    rescue => error
      response(error: { source: self.class.to_, message: error.message })
    end

    private

    attr_reader :params

    def build_invoice
      Invoice.new(**build_params)
    end
  end
end
