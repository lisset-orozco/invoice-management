# frozen_string_literal: true

require 'zip'

module Invoices
  class ProcessZipFileService < BaseService
    def initialize(params)
      super()

      @params = params
    end

    def call
      process_zip_file

      response(success: true, payload: invoice_xml_paths)
    rescue => error
      response(error: { source: self.class.to_s, message: error.message })
    end

    private

    attr_reader :params, :invoice_xml_paths

    def process_zip_file
      Zip::File.open(params[:file_path]) do |zip_file|
        @invoice_xml_paths = []
        zip_file.each do |file|
          next unless file.name.include?('.xml')

          Rails.logger.info("Extracting #{file.name}")
          extract_xml_file(zip_file, file)
        end
      end
    end

    def extract_xml_file(zip_file, file)
      file_name = file.name.split('/').last
      file_path = "#{params[:root_path]}/#{file_name}"

      zip_file.extract(file, file_path)
      @invoice_xml_paths << file_path
    end
  end
end
