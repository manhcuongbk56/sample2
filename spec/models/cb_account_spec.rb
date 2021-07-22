require 'rails_helper'

describe CbAccount do
  context 'associations' do
    it 'has many cb_accounts_consent_forms' do
      association = CbAccount.reflect_on_association(:cb_accounts_consent_forms)
      expect(association).not_to be nil
      expect(association.macro).to eq(:has_many)
    end

    it 'has many consent_forms through cb_accounts_consent_forms' do
      association = CbAccount.reflect_on_association(:consent_forms)
      expect(association).not_to be nil
      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:cb_accounts_consent_forms)
    end

    it 'has many deposits' do
      association = CbAccount.reflect_on_association(:deposits)
      expect(association).not_to be nil
      expect(association.macro).to eq(:has_many)
    end
  end
end