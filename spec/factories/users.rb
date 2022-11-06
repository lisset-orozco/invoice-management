# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password }
    rfc { Faker::Alphanumeric.alphanumeric(number: 10) }
  end
end
