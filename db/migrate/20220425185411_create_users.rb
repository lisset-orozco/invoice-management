# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table(:users, comment: 'Table of users') do |t|
      t.string(:rfc, null: false, index: { unique: true })
      t.string(:email, null: false, index: { unique: true })
      t.string(:password_digest, null: false)

      t.timestamps
    end
  end
end
