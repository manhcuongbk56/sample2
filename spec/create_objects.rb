def create_account_and_deposits_objects
  return if @cb_account
  @cb_account = FactoryBot.create(:cb_account, uuid: "#{UUID_GENERATOR.generate}-#{Time.now.to_f}")
  sleep 0.5
  @cb_account_2 = FactoryBot.create(:cb_account, uuid: "#{UUID_GENERATOR.generate}-#{Time.now.to_f}")

  @consent_form = FactoryBot.create(:consent_form,  { required_for: ConsentForm::ACCEPTANCE_REQUIRED_FOR[:account] } )
  @cb_account.consent_forms <<  @consent_form

  @cb_account_2.consent_forms <<  @consent_form
  @cb_account_2.save!

  @consent_form_2 = FactoryBot.create(:consent_form,  { required_for: ConsentForm::ACCEPTANCE_REQUIRED_FOR[:account] } )
  @cb_account.consent_forms <<  @consent_form_2

  @permission = FactoryBot.create(:permission, { name: 'ALL' })
  @role       = FactoryBot.create(:role, { name: 'OWNER' })
  @permission.roles << @role
  @permission.save!

  @role.permissions << @permission
  @role.save!

  @deposit = DepositService.create_deposit({
               cb_account_id: @cb_account.id,
               account_uuid: @cb_account.uuid,
               deposit_type: Deposit::DEPOSIT_TYPES[:permanent],
               product: 'cb',
               babies: 1,
               payment_plan: '24_months',
               storage_plan: 'prepaid_18'
             }.with_indifferent_access).first

  @deposit_consent_form = FactoryBot.create(:consent_form,  { required_for: ConsentForm::ACCEPTANCE_REQUIRED_FOR[:deposit] } )

  @deposit.consent_forms << @deposit_consent_form
  @deposit.cb_accounts << @cb_account
  @deposit.save!

  @payments = DepositService.create_payments(@deposit, @deposit.price)

  @cb_account.deposits << @deposit

  @cb_account.save!

  @consent_form_2.cb_accounts_consent_forms[0].deleted = true
  @consent_form_2.cb_accounts_consent_forms[0].save!

  @cb_account.reload
end

create_account_and_deposits_objects
