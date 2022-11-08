# frozen_string_literal: true

module Invoices
  class SearchService < BaseService
    def initialize(params)
      super()

      @params = params
    end

    def call
      response(success: true, payload: search_invoices)
    rescue => error
      response(error: { source: self.class.to_s, message: error.message })
    end

    private

    attr_reader :params

    def search_invoices
      response = ::Invoices::SearchQuery.call(params)
      raise(response.error) unless response.success?

      response.payload
    end
  end
end
