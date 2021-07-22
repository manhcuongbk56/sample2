class AccountService
  class << self

    # Return a hash that represents the account info
    def get_account(account_uuid)
      

      # Query data from Cord Blood Account cb_account and associations: consent forms, deposits
      cb_account = CbAccount.includes( { cb_accounts_consent_forms: :consent_form }, 
                                       { deposits: { deposits_consent_forms: :consent_form } } ).find_by_uuid(account_uuid)
      
      if cb_account.nil?
        cb_account = create_cb_account(account_uuid)
      end

      # Call to Patient Portal - later on maybe UserService to get user information
      # account is a hash
      account = get_user(account_uuid)
      
      # Later on we must call Stripe to get Stripe customer information and payment source

      account['cb_account'] = cb_account
      account
    end


    # This one eventually will call API in Patient Portal or User Service
    # For now, just put some dummy thing here
    def get_user(uuid)
      {
        'uuid'          =>  uuid,
        'first_name'    => 'George',
        'last_name'     => 'Washington',
        'date_of_birth' => '1809-02-12',
        'email'         => 'george.washington@whitehouse.gov',
        'created_at'    => '2015-05-25 13:05:59 -0700'
      }
    end

    def create_cb_account(uuid)
      # Later we might want to call to User service to verify if a User with uuid really exists.
      
      # Create a Stripe customer, get Stripe customer id
      customer = Finance::CoreService.create_customer({
                                        description: "CBS #{uuid}",
                                        metadata: { uuid: uuid}
                                      })

      # Create a cb_account with uuid and stripe_customer_id
      cb_account = CbAccount.new(uuid: uuid, stripe_customer_id: customer.id)
      consent_forms = ConsentForm.where( required_for: ConsentForm::ACCEPTANCE_REQUIRED_FOR[:account] ).to_a
      cb_account.consent_forms = consent_forms
      cb_account.save!
      cb_account
    end

    def accept_consent_form(account_uuid, consent_form_id)
      # Find the account with the uuid
      cb_account = CbAccount.includes(:consent_forms, :deposits).find_by_uuid(account_uuid)
      raise ObjectNotFoundException.new("Cord Blood Account with uuid #{account_uuid} does not exists.") unless cb_account

      ConsentFormService.create_accepted_link(cb_account.id, consent_form_id, 'cb_account')
      
      # Return the Account with all nested attributes
      get_account(account_uuid)
    end
  end
end