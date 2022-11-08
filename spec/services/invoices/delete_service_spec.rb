# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Invoices::DeleteService, type: :service) do
  let(:service) { described_class }
  let(:invoice) { create(:invoice, status: 'active') }
  let(:invoice_params) { build(:invoice_params).merge(user_id: invoice.user_id, invoice_uuid: invoice.invoice_uuid) }

  describe '#call' do
    context 'when success' do
      let(:run_at) { Time.parse('2022-11-08 13:00:00 -0600').in_time_zone('Mexico City') }

      around do |example|
        travel_to(run_at)
        example.run
        travel_back
      end

      it 'updated invoice with status inactive' do
        result =
          expect do
            service.call(invoice_params)
            invoice.reload
          end
        result.to change(invoice, :status).from('active').to('inactive')
      end

      it 'updated invoice deleted_at from nil to date' do
        result =
          expect do
            service.call(invoice_params)
            invoice.reload
          end
        result.to change(invoice, :deleted_at).from(nil).to(run_at)
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
