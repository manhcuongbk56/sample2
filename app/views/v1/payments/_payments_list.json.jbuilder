json.payments payments do |payment|
   json.partial! '/v1/payments/payment', locals: { payment: payment }
end