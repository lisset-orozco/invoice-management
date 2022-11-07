# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Auth::GenerateJwtUtil, type: :util) do
  let(:util) { described_class }
  let(:user) { create(:user, email: 'test@test.com') }
  let(:payload) do
    {
      user_id: user.id,
      email: user.email
    }
  end

  describe '#call' do
    before do
      stub_const('Auth::JwtBase::JWT_SECRET', 'test')
    end

    context 'when success' do
      it 'returns an encoded token' do
        result = util.call(payload)

        expect(result).to have_attributes(success?: true, payload: a_kind_of(String), error: nil)
      end
    end

    context 'when fails' do
      it 'returns an error due to missing params' do
        result = util.call({})

        expect(result).to have_attributes(
          success?: false,
          error: { message: 'Missing params', source: 'Auth::GenerateJwtUtil' }
        )
      end
    end
  end
end
