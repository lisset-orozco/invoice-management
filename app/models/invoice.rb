# frozen_string_literal: true

class Invoice < ApplicationRecord
  validates :invoice_uuid, :emitter_name, :emitter_rfc, :receiver_name, :receiver_rfc, :amount,
            :currency, :emitted_at, :expires_at, :signed_at, :cfdi_digital_stamp, presence: true

  validates :invoice_uuid, uniqueness: { scope: %i[user_id status] }, if: :active?

  enum status: { active: 'active', inactive: 'inactive', pending: 'pending' }

  belongs_to :user
end
