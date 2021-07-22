class CbAccountsConsentForm < ApplicationRecord
  include ActiveRecordScope

  belongs_to :cb_account
  belongs_to :consent_form

end

