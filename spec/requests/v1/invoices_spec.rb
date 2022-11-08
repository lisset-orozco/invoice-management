# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('v1/invoices', type: :request) do
  let(:user) { create(:user) }
  let(:invoice_params) { build(:invoice_params) }
  let(:token_params) { { user_id: user.id, email: user.email } }

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new invoice' do
        result = expect { request_auth(:post, '/v1/invoices', token_params, invoice_params) }
        result.to change(Invoice, :count).by(1)
      end

      it 'renders a JSON response with the new invoice' do
        request_auth(:post, '/v1/invoices', token_params, invoice_params)

        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'when missing token auth in headers' do
      it 'returns unauthorized' do
        request_auth(:post, '/v1/invoices', {}, invoice_params)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /update' do
    let(:invoice) { create(:invoice, user_id: user.id) }
    let(:endpoint) { "/v1/invoices/#{invoice.invoice_uuid}" }
    let(:params) { invoice_params.merge(user_id: invoice.user_id, invoice_uuid: invoice.invoice_uuid) }

    context 'with valid parameters' do
      it 'update an invoice' do
        request_auth(:put, endpoint, token_params, invoice_params)

        expect(response).to have_http_status(:ok)

        expect(json_body['data']['invoice_uuid']).to eq(invoice.invoice_uuid)
        expect(json_body['data']['user_id']).to eq(invoice.user_id)
        expect(json_body['data']['created_at']).not_to eq(json_body['data']['updated_at'])
      end

      it 'renders a JSON response with the new invoice' do
        request_auth(:put, endpoint, token_params, invoice_params)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'when missing token auth in headers' do
      it 'returns unauthorized' do
        request_auth(:put, endpoint, {}, invoice_params)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
