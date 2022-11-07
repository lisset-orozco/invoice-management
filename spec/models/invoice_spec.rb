# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Invoice, type: :model) do
  subject(:invoice) { build(:invoice) }

  describe 'object' do
    it 'is valid' do
      expect(invoice).to be_valid
    end

    it 'is not valid without email' do
      invoice.invoice_uuid = nil
      expect(invoice).not_to be_valid
    end

    it 'created' do
      result = expect { invoice.save! }
      result.to change(described_class, :count).by(1)
    end
  end

  describe 'enum' do
    it do
      expect(invoice).to define_enum_for(:status)
        .with_values(
          active: 'active',
          inactive: 'inactive',
          pending: 'pending'
        )
        .backed_by_column_of_type(:string)
    end
  end

  describe 'validations' do
    context 'when present' do
      it { is_expected.to validate_presence_of(:invoice_uuid) }
      it { is_expected.to validate_presence_of(:amount) }
      it { is_expected.to validate_presence_of(:emitter_rfc) }
    end

    context 'when unique' do
      it { is_expected.to validate_uniqueness_of(:invoice_uuid).scoped_to(:user_id, :status) }
    end

    context 'when duplicated' do
      let(:duplicated_invoice) do
        invoice.save!
        invoice.dup
      end

      it 'has already been taken invoice_uuid, user_id, status' do
        result = expect { duplicated_invoice.save! }

        result.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Invoice uuid has already been taken')
      end
    end
  end

  describe 'relations' do
    it { is_expected.to belong_to(:user) }
  end
end
