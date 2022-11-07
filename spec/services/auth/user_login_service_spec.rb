# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Auth::UserLoginService, type: :service) do
  let(:util) { described_class }
  let(:user) { create(:user, email: 'test@test.com', password: 'example123') }
  let(:payload) do
    {
      email: user.email,
      password: user.password
    }
  end

  describe '#call' do
    context 'when success' do
      it 'returns an encoded token' do
        allow(Auth::GenerateJwtUtil).to receive(:call).and_call_original

        result = util.call(payload)

        expect(result).to have_attributes(success?: true, payload: { token: a_kind_of(String) }, error: nil)
        expect(Auth::GenerateJwtUtil).to have_received(:call)
      end
    end

    context 'when fails' do
      it 'returns an error due to missing params' do
        result = util.call({})

        expect(result).to have_attributes(
          success?: false,
          error: { message: 'Missing params', source: 'Auth::UserLoginService' }
        )
      end

      it 'returns an error due to missing invalid email' do
        result = util.call({ email: 'fail@fail.com', password: user.password })

        expect(result).to have_attributes(
          success?: false,
          error: { message: 'Wrong credentials', source: 'Auth::UserLoginService' }
        )
      end

      it 'returns an error due to missing invalid password' do
        result = util.call({ email: user.email, password: 'fail_pass' })

        expect(result).to have_attributes(
          success?: false,
          error: { message: 'Wrong credentials', source: 'Auth::UserLoginService' }
        )
      end
    end
  end
end
