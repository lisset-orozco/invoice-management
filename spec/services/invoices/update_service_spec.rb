# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Invoices::UpdateService, type: :service) do
  let(:service) { described_class }
  let(:invoice) { create(:invoice) }
  let(:invoice_params) { build(:invoice_params).merge(user_id: invoice.user_id, invoice_uuid: invoice.invoice_uuid) }

  describe '#call' do
    context 'when success' do
      it 'updated invoice' do
        result = service.call(invoice_params)

        expect(result.success?).to be(true)
        expect(invoice.user_id).to eq(result.payload.user_id)
        expect(invoice.invoice_uuid).to eq(result.payload.invoice_uuid)
        expect(invoice.created_at).to eq(result.payload.created_at)
        expect(invoice.updated_at).not_to eq(result.payload.updated_at)
      end

      it 'returns an updated object invoice' do
        result = service.call(invoice_params)

        expect(result.success?).to be(true)
        expect(result.payload.class).to eq(Invoice)
      end
    end

    context 'when fails' do
      it 'returns an error due to invalid params' do
        result = service.call({})

        expect(result.success?).to be(false)
        expect(result.error[:source]).to eq('Invoices::UpdateService')
        expect(result.error[:message]).to include('Invoice not found')
      end
    end
  end
end
