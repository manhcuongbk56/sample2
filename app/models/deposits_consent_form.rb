class DepositsConsentForm < ApplicationRecord
  include ActiveRecordScope
  
  belongs_to :deposit
  belongs_to :consent_form
end

