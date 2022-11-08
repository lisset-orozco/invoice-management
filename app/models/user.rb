# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :rfc, :email, :password, presence: true
  validates :rfc, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true

  has_many :invoices, dependent: :destroy
end
