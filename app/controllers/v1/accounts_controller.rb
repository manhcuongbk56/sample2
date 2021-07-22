module V1
  class AccountsController < ApplicationController
    ERROR_GET_ACCOUNT = 'Error during getting account.'

    before_action :authentication

    # GET /v1/accounts/:id
    def show
      process_request(ERROR_GET_ACCOUNT) do
        @account = AccountService.get_account(params[:id])
      end
    end

    # Right now we don't need to update CB account
    def update
      raise ' Right now we don not need to update CB account'
    end


    # POST /v1/accounts/:account_id/consent with body { consent_form: form_id }
    # Accept consent form required for account level.
    def accept_consent
      process_request(ERROR_ACCEPT_CONSENT_FORM) do
        body = JSON.parse(request.body.read)
        @account = AccountService.accept_consent_form(params[:account_id], body['consent_form'])
      end
    end

  end # class AccountsController
end # module V1