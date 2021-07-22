json.extract! deposit, :id, :deposit_type, :product, :babies, :payment_plan, :storage_plan, :expected_due_date, :price, :purchase_id
# hospital and physician will come later

json.partial! '/v1/consent_forms/forms_details', locals: { consent_form_links: deposit.deposits_consent_forms }
json.partial! '/v1/payments/payments_list', locals: { payments: deposit.payments }
