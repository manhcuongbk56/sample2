%w{ uuid first_name last_name date_of_birth email created_at }.each do |attr|
  eval("json.#{attr} '#{@account[attr]}'")
end

cb_account = @account['cb_account']
json.partial! '/v1/consent_forms/forms_details', locals: { consent_form_links: cb_account.cb_accounts_consent_forms }
json.partial! '/v1/deposits/deposits_details', locals: { deposits: cb_account.deposits }