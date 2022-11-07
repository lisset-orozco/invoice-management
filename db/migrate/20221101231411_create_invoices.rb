# frozen_string_literal: true

class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table(:invoices, comment: 'Invoices table') do |t|
      t.references(:user, foreign_key: true, null: false)
      t.string(:invoice_uuid, limit: 36, null: false)
      t.string(:status, default: 'active', null: false)
      t.string(:emitter_name, null: false)
      t.string(:emitter_rfc, null: false)
      t.string(:receiver_name, null: false)
      t.string(:receiver_rfc, null: false)
      t.bigint(:amount, null: false)
      t.string(:currency, null: false)
      t.datetime(:emitted_at, null: false)
      t.datetime(:expires_at, null: false)
      t.datetime(:signed_at, null: false)
      t.text(:cfdi_digital_stamp, null: false)
      t.datetime(:deleted_at)

      t.timestamps
    end
  end
end
