# frozen_string_literal: true

module Invoices
  class ImportZipFileJob < ApplicationJob
    def perform(file_path:, user_id:)
      Invoices::ImportZipFileUseCase.call(file_path:, user_id:)
    rescue => error
      Rails.logger.error("ERROR 'Invoices::ImportZipFileJob.perform': #{error}")
    end
  end
end
