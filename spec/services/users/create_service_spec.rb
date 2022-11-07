# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Users::CreateService, type: :service) do
  let(:service) { described_class }
  let(:user_params) do
    {
      email: Faker::Internet.unique.email,
      password: Faker::Internet.password,
      rfc: Faker::Alphanumeric.alphanumeric(number: 10)
    }
  end

  describe '#call' do
    context 'when success' do
      it 'created user' do
        result = expect { service.call(user_params) }
        result.to change(User, :count).by(1)
      end

      it 'returns an object user' do
        result = service.call(user_params)

        expect(result.success?).to be(true)
        expect(result.payload.class).to eq(User)
      end
    end

    context 'when fails' do
      it 'returns an error due to invalid params' do
        result = service.call({})

        expect(result.success?).to be(false)
        expect(result.error[:source]).to eq('Users::CreateService')
        expect(result.error[:message]).to include(
          "Validation failed: Password can't be blank, " \
          "Rfc can't be blank, " \
          "Email can't be blank, " \
          "Password can't be blank, Email is invalid"
        )
      end
    end
  end
end
