class CbAccountsDeposit < ApplicationRecord
  belongs_to :cb_account
  belongs_to :deposit
  belongs_to :role
end
