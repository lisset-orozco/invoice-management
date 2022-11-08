# frozen_string_literal: true

module Invoices
  class SearchQuery < ApplicationQuery
    def initialize(params)
      super()

      @scope = Invoice.all
      @params = params || {}
    end

    def call
      response(success: true, payload: search_invoices)
    rescue
      response(error: StandardError.new(self))
    end

    private

    attr_reader :params, :scope

    def search_invoices
      @scope = with_user_id
      @scope = with_status
      @scope = with_emitter_name
      @scope = with_emitter_rfc
      @scope = with_receiver_name
      @scope = with_receiver_rfc
      @scope = with_range_amount

      scope.page(params[:page_number]).per(params[:page_size])
    end

    def with_user_id
      scope.where(user_id: params[:user_id])
    end

    def with_status
      status = params[:status]
      return scope unless status

      scope.where(status:)
    end

    def with_emitter_name
      emitter_name = params[:emitter_name]
      return scope unless emitter_name

      scope.where(emitter_name:)
    end

    def with_emitter_rfc
      emitter_rfc = params[:emitter_rfc]
      return scope unless emitter_rfc

      scope.where(emitter_rfc:)
    end

    def with_receiver_name
      receiver_name = params[:receiver_name]
      return scope unless receiver_name

      scope.where(receiver_name:)
    end

    def with_receiver_rfc
      receiver_rfc = params[:receiver_rfc]
      return scope unless receiver_rfc

      scope.where(receiver_rfc:)
    end

    def with_range_amount
      min = params[:min_amount]
      max = params[:max_amount]
      return scope unless min.present? && max.present?

      scope.where('amount BETWEEN ? AND ?', min, max)
    end
  end
end
