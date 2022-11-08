# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('v1/auth', type: :request) do
  let(:user) { create(:user) }
  let(:valid_params) do
    {
      email: user.email,
      password: user.password
    }
  end

  describe 'POST /login' do
    context 'with valid parameters' do
      it 'returns a token for a logged user' do
        request(:post, '/v1/login', valid_params)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
        expect(json_body).to include({ 'data' => { 'token' => a_kind_of(String) } })
      end
    end

    context 'with invalid parameters does not create a token' do
      it 'renders an error due to missing params' do
        request(:post, '/v1/login', {})

        commom_error_response('Missing params')
      end

      it 'renders an error due to invalid password' do
        request(:post, '/v1/login', { email: user.email, password: '1234fail' })

        commom_error_response('Wrong credentials')
      end

      it 'renders an error due to invalid email' do
        request(:post, '/v1/login', { email: 'fail@fail.com', password: user.password })

        commom_error_response('Wrong credentials')
      end

      def commom_error_response(error_messaje)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
        expect(json_body).to include(
          {
            'error' => { 'source' => 'Auth::UserLoginService', 'message' => error_messaje }
          }
        )
      end
    end
  end
end
