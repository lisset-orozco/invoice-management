# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('v1/users', type: :request) do
  let(:valid_attributes) do
    {
      email: Faker::Internet.unique.email,
      password: Faker::Internet.password,
      rfc: Faker::Alphanumeric.alphanumeric(number: 10)
    }
  end

  let(:invalid_attributes) do
    { email: '', rfc: ' ', password: nil, anything: 'anything' }
  end

  let(:valid_headers) do
    {}
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new User' do
        result = expect { post(v1_users_url, params: valid_attributes, headers: valid_headers, as: :json) }
        result.to change(User, :count).by(1)
      end

      it 'renders a JSON response with the new user' do
        post v1_users_url, params: valid_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        result =
          expect do
            post(v1_users_url, params: invalid_attributes, as: :json)
          end

        result.to change(User, :count).by(0)
      end

      it 'renders a JSON response with errors for the new user' do
        post v1_users_url, params: invalid_attributes, headers: valid_headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end
end
