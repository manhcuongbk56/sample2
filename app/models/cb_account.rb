class CbAccount < ApplicationRecord
  include ActiveRecordScope

  # consent forms
  has_many :cb_accounts_consent_forms # dependent: :destroy does not work with soft delete
  has_many :consent_forms, through: :cb_accounts_consent_forms

  # deposits
  has_many :cb_accounts_deposits
  has_many :deposits, through: :cb_accounts_deposits

  has_many :purchases

  validates_uniqueness_of :uuid
end
