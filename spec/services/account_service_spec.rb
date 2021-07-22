require 'rails_helper'

describe AccountService do
  before :all do
    create_account_and_deposits_objects
  end

  context 'get_account' do
    it 'returns existing account' do
      account = AccountService.get_account(@cb_account.uuid)
      expect(account).not_to be nil
      expect(account.is_a?(Hash)).to be true

      expect(account['cb_account']).not_to be nil
    end

    # it 'raises ObjectNotFoundException if the cb_account with passed uuid does not exist' do
    #   expect { AccountService.get_account('wrong uuid') }.to raise_error(ObjectNotFoundException)
    # end

    it 'creates new cb_account if the cb_account with passed uuid does not exist' do
      uuid = "#{UUID_GENERATOR.generate}-#{Time.now.to_f}"
      account = AccountService.get_account(uuid)
      expect(account).not_to be nil
      expect(account.is_a?(Hash)).to be true

      expect(account['cb_account']).not_to be nil
      expect(account['cb_account'].uuid).to eql(uuid)
      expect(account['cb_account'].consent_forms.any?).to be true
    end

  end

  context 'accept_consent_form' do
    it 'accepts existing required consent form successfully' do
      account = AccountService.accept_consent_form(@cb_account.uuid, @consent_form.id)

      links = CbAccountsConsentForm.where(cb_account_id: @cb_account.id, consent_form_id: @consent_form.id).to_a
      
      # Now default scope is active, there must be only one link
      expect(links.size).to eql(1)
      active_link = links.first
      expect(active_link.accept_state).to eql(ConsentForm::ACCEPT_STATES[:accepted])

      # Make sure that the returned account has the correct link on it  
      form_link = account['cb_account'].cb_accounts_consent_forms.first
      expect(form_link.accept_state).to eql(ConsentForm::ACCEPT_STATES[:accepted])
    end

    it 'raises ObjectNotFoundException if cb_account does not exist' do
      expect { AccountService.accept_consent_form('wrong uuid', @consent_form.id) }.to raise_error(ObjectNotFoundException)
    end
  end

  context 'create_cb_account' do
    it 'creates new account for a given uuid' do
      uuid = "#{UUID_GENERATOR.generate}-#{Time.now.to_f}"
      cb_account = AccountService.create_cb_account(uuid)
      expect(cb_account).not_to be nil
      expect(cb_account.consent_forms.any?).to be true
      customer = Finance::CoreService.get_customer(cb_account.stripe_customer_id)
      expect(customer).not_to be nil
      expect(customer.metadata.to_h).to eql({ uuid: cb_account.uuid})

    end

  end

  context 'get_user' do
  end
end
