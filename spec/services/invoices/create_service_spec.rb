# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Invoices::CreateService, type: :service) do
  let(:service) { described_class }
  let(:invoice_params) { build(:invoice_params).merge(user_id: create(:user).id) }

  describe '#call' do
    context 'when success' do
      it 'created invoice' do
        result = expect { service.call(invoice_params) }
        result.to change(Invoice, :count).by(1)
      end

      it 'returns an object user' do
        result = service.call(invoice_params)

        expect(result.success?).to be(true)
        expect(result.payload.class).to eq(Invoice)
      end
    end

    context 'when fails' do
      it 'returns an error due to invalid params' do
        result = service.call({})

        expect(result.success?).to be(false)
        expect(result.error[:source]).to eq('Invoices::CreateService')
        expect(result.error[:message]).to include('Validation failed: ')
      end
    end
  end
end
