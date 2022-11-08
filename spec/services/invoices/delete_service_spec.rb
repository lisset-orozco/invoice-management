# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Invoices::DeleteService, type: :service) do
  let(:service) { described_class }
  let(:invoice) { create(:invoice, status: 'active') }
  let(:invoice_params) { build(:invoice_params).merge(user_id: invoice.user_id, invoice_uuid: invoice.invoice_uuid) }

  describe '#call' do
    context 'when success' do
      it 'updated invoice with status inactive' do
        result = service.call(invoice_params)

        expect(result.success?).to be(true)
        expect(result.payload.id).to eq(invoice.id)
        expect(result.payload.status).to eq('inactive')
        expect(result.payload.deleted_at).not_to be_nil
      end

      it 'returns an updated object invoice' do
        result = service.call(invoice_params)

        expect(result.success?).to be(true)
        expect(result.payload.class).to eq(Invoice)
      end
    end

    context 'when fails' do
      it 'returns an error due to missing params' do
        result = service.call({})
        common_expected_error(result)
      end

      it 'returns an error due to invalid invoice_uuid' do
        result = service.call({ user_id: invoice.user_id, invoice_uuid: 'fake' })
        common_expected_error(result)
      end

      def common_expected_error(result)
        expect(result.success?).to be(false)
        expect(result.error[:source]).to eq('Invoices::DeleteService')
        expect(result.error[:message]).to include('Invoice not found')
      end
    end
  end
end
