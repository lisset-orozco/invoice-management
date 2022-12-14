# frozen_string_literal: true

module V1
  class InvoicesController < ApplicationController
    include ActionController::MimeResponds

    def create
      response = Invoices::CreateService.call(invoice_params)
      default_response(response, :created)
    end

    def update
      response = Invoices::UpdateService.call(invoice_params)
      default_response(response, :ok)
    end

    def destroy
      response = Invoices::DeleteService.call(invoice_params)
      default_response(response, :ok)
    end

    def index
      response = Invoices::SearchService.call(search_params)

      if response.success?
        render(json: { data: paginate(response.payload) })
      else
        render(json: { error: response.error }, status: :unprocessable_entity)
      end
    end

    def import_zip_file
      Invoices::ImportZipFileJob.perform_later(file_path: params[:file_path].path, user_id: params[:user_id])

      render(json: { message: 'Processing invoices' })
    end

    def qr_code
      invoice = Invoices::SearchService.call(**qr_code_params).payload
      response = QrCodeUtil.call(str_qr: invoice.first.cfdi_digital_stamp)

      if response.success?
        send_data(response.payload.to_s, type: 'image/png', disposition: 'inline')
      else
        render(json: { error: response.error }, status: :unprocessable_entity)
      end
    end

    private

    def default_response(response, status)
      if response.success?
        render(json: { data: response.payload }, status:)
      else
        render(json: { error: response.error }, status: :unprocessable_entity)
      end
    end

    def invoice_params
      params.permit(
        :user_id,
        :invoice_uuid,
        :status,
        :emitted_at,
        :expires_at,
        :signed_at,
        :cfdi_digital_stamp,
        emitter: %i[name rfc],
        receiver: %i[name rfc],
        amount: %i[cents currency]
      )
    end

    def search_params
      params.permit(
        :user_id,
        :status,
        :emitter_name,
        :emitter_rfc,
        :receiver_name,
        :receiver_rfc,
        :min_amount,
        :max_amount,
        :page_number,
        :page_size
      )
    end

    def qr_code_params
      params.permit(:user_id, :invoice_uuid)
    end
  end
end
