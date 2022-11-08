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
end
