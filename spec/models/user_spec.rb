# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(User, type: :model) do
  subject(:user) { build(:user) }

  describe 'object' do
    it 'is valid' do
      expect(user).to be_valid
    end

    it 'is not valid without email' do
      user.email = nil
      expect(user).not_to be_valid
    end
  end

  describe 'validations' do
    context 'when present' do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_presence_of(:password) }
      it { is_expected.to validate_presence_of(:rfc) }
    end

    context 'when unique' do
      it { is_expected.to validate_uniqueness_of(:email) }
      it { is_expected.to validate_uniqueness_of(:rfc) }
    end
  end
end
