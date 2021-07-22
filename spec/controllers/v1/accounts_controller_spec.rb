require 'rails_helper'

describe V1::AccountsController do

  before :each do
    # Later, when we change authentication mechanism, we must change this code
    request.headers['api-token'] = HmacAuthentication.sha3_hmac_token
    request.headers['CONTENT_TYPE'] = 'application/json'

    create_account_and_deposits_objects
  end

  context 'show' do
    it 'returns account details' do
      get :show, params: { id: @cb_account.uuid, format: :json }

      expect(response).to have_http_status(:ok)
      expect(response).to render_template('v1/accounts/show')
      account_info = JSON.parse(response.body)

      %w{ uuid first_name last_name date_of_birth email created_at consent_forms deposits }.each do |attr|
        expect(account_info[attr]).not_to be nil
      end
    end

    it 'returns 403:forbidden if authentication fails' do
      request.headers['api-token'] = 'wrong token'
      get :show, params: { id: @cb_account.uuid }

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns 404:not_found if the account with passed uuid does not exist' do
      allow(AccountService).to receive(:get_account).with('12345').and_raise(ObjectNotFoundException.new('Account does not exist.'))
      get :show, params: { id: '12345' }

      expect(response).to have_http_status(:not_found)
    end

    it 'returns 500:internal_server_error if a generic error happens' do
      allow(AccountService).to receive(:get_account).with(@cb_account.uuid).and_raise('Something wrong happens')
      get :show, params: { id: @cb_account.uuid }

      expect(response).to have_http_status(:internal_server_error)
    end
  end

  # Right now we don't need to update CB account
  context 'update' do
    it 'updates account successfully' do
      # Don't really test anything here
    end
  end

  context 'accept_consent' do
    # POST /v1/accounts/:account_id/consent

    it 'accepts consent form successfully' do
      request.env['RAW_POST_DATA'] = { consent_form:  @consent_form.id }.to_json
      post :accept_consent, params: {account_id: @cb_account.uuid, format: :json }
      expect(response).to have_http_status(:ok)
      account_info = JSON.parse(response.body)
      form_info = account_info['consent_forms'].detect { |x| x['id'] == @consent_form.id }
      expect(form_info['status']).to eql(ConsentForm::ACCEPT_STATES[:accepted])
    end

    it 'returns 403:forbidden if authentication fails' do
      request.headers['api-token'] = 'wrong token'
      request.env['RAW_POST_DATA'] = { consent_form: @consent_form.id }.to_json
      post :accept_consent, params: {account_id: @cb_account.uuid }

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns 404:not_found if the account with passed uuid does not exist' do
      allow(AccountService).to receive(:accept_consent_form).and_raise(ObjectNotFoundException.new('Account does not exist.'))
      request.env['RAW_POST_DATA'] = { consent_form: @consent_form.id }.to_json
      post :accept_consent, params: {account_id: @cb_account.uuid}

      expect(response).to have_http_status(:not_found)
    end

    it 'returns 500:internal_server_error if a generic error happens' do
      allow(AccountService).to receive(:accept_consent_form).and_raise('Something wrong happens')
      request.env['RAW_POST_DATA'] = { consent_form: @consent_form.id }.to_json
      post :accept_consent, params: {account_id: @cb_account.uuid}

      expect(response).to have_http_status(:internal_server_error)
    end
  end

end
