# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    user
    invoice_uuid { SecureRandom.uuid }
    status { 'active' }
    emitter_name { Faker::Name.name }
    emitter_rfc { Faker::Alphanumeric.alphanumeric(number: 10) }
    receiver_name { Faker::Alphanumeric.alphanumeric(number: 10) }
    receiver_rfc { Faker::Alphanumeric.alphanumeric(number: 10) }
    amount { Faker::Number.number(digits: 10) }
    currency { Faker::Currency.code }
    emitted_at { Time.zone.now }
    expires_at { Time.zone.now + 10 }
    signed_at { Time.zone.now }
    cfdi_digital_stamp { Faker::Alphanumeric.alphanumeric(number: 255) }
    deleted_at { nil }
  end

  factory :invoice_params, class: 'Hash' do
    skip_create
    initialize_with do
      {
        invoice_uuid: SecureRandom.uuid,
        status: 'active',
        emitter: {
          name: Faker::Name.name,
          rfc: Faker::Alphanumeric.alphanumeric(number: 10)
        },
        receiver: {
          name: Faker::Name.name,
          rfc: Faker::Alphanumeric.alphanumeric(number: 10)
        },
        amount: {
          cents: Faker::Number.number(digits: 10),
          currency: Faker::Currency.code
        },
        emitted_at: Time.zone.now,
        expires_at: Time.zone.now + 10,
        signed_at: Time.zone.now,
        cfdi_digital_stamp: Faker::Alphanumeric.alphanumeric(number: 255)
      }
    end
  end
end
