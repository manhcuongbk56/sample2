class ConsentForm < ApplicationRecord
  include ActiveRecordScope
  
  ACCEPT_STATES = {
    pending:  'PENDING',
    accepted: 'ACCEPTED',
    rejected: 'REJECTED'
  }

  # Later on we might need more sophisticated runles to 
  # reuqire forms' acceptances
  ACCEPTANCE_REQUIRED_FOR = {
    account: 'ACCOUNT',
    deposit: 'DEPOSIT'
  }

  has_many :cb_accounts_consent_forms
  has_many :cb_accounts, through: :cb_accounts_consent_forms

  has_many :deposits_consent_forms
  has_many :deposits, through: :deposits_consent_forms

end
