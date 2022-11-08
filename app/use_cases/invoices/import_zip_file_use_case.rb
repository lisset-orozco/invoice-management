# frozen_string_literal: true

module Invoices
  class ImportZipFileUseCase < ApplicationUseCase
    def initialize(params)
      super()

      @params = params
    end

    def call
      process_zip_file
      build_invoices
      create_bulk_invoices
      remove_files

      response(success: true, payload: 'Invoices created')
    rescue => error
      response(error: { source: self.class, message: error.message })
    end

    private

    attr_reader :params, :invoice_xml_paths, :payload, :invoices

    def dir_path
      @dir_path ||= Rails.root.join("tmp/xml_invoices/#{params[:user_id]}_#{Time.now.to_i}")
    end

    def root_path
      @root_path ||= FileUtils.mkdir_p(dir_path)[0]
    end

    def process_zip_file
      result = Invoices::ProcessZipFileService.call(root_path:, file_path: params[:file_path])
      raise(StandardError, result.error) unless result.success?

      @invoice_xml_paths = result.payload
    end

    def build_invoices
      @invoices = []
      invoice_xml_paths.each do |xml_path|
        extract_hash_from_xml(xml_path)

        result = Invoices::BuildService.call(user_id: params[:user_id], **payload.deep_symbolize_keys)
        @invoices << result.payload
      end
    end

    def create_bulk_invoices
      Invoice.transaction do
        Invoice.import(invoices) if invoices.present?
      end
    end

    def extract_hash_from_xml(invoice_path)
      File.open(invoice_path) do |xml_file|
        @payload = Hash.from_xml(xml_file)['hash']
      end
    end

    def remove_files
      FileUtils.remove_dir(root_path)
    end
  end
end
