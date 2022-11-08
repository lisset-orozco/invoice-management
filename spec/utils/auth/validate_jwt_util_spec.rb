# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Auth::ValidateJwtUtil, type: :util) do
  let(:util) { described_class }
  let(:token) do
    'eyJhbGciOiJIUzI1NiJ9' \
      '.eyJ1c2VyX2lkIjoxLCJlbWFpbCI6InRlc3RAdGVzdC5jb20iLCJleHBpcmVzX2luIjozMzM1Njg0NjM5fQ' \
      '.FYk_JeiFRr9fkB_oyHWJioxPBulHwPt2flseYIfahgc'
  end
  let(:expired_token) do
    'eyJhbGciOiJIUzI1NiJ9' \
      '.eyJ1c2VyX2lkIjoxLCJlbWFpbCI6InRlc3RAdGVzdC5jb20iLCJleHBpcmVzX2luIjoxNjY3NzE1MTkxfQ' \
      '.GExyiCHdvB5aR6xaayGS8OWSkHotfgkPeJTYRWv6lqY'
  end

  describe '#call' do
    before do
      stub_const('Auth::JwtBase::JWT_SECRET', 'test')
    end

    context 'when success' do
      it 'returns a decoded token' do
        result = util.call(token:)

        expect(result).to have_attributes(
          success?: true,
          payload: { 'email' => 'test@test.com', 'expires_in' => a_kind_of(Integer), 'user_id' => 1 },
          error: nil
        )
      end
    end

    context 'when fails' do
      it 'returns an error due to missing params' do
        result = util.call({})

        expect(result).to have_attributes(
          success?: false,
          error: { message: 'Missing params', source: 'Auth::ValidateJwtUtil' }
        )
      end

      it 'returns an error due to expired token' do
        result = util.call(token: expired_token)

        expect(result).to have_attributes(
          success?: false,
          error: { message: 'Token is expired', source: 'Auth::ValidateJwtUtil' }
        )
      end
    end
  end
end
