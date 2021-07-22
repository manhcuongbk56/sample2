require 'rails_helper'

describe AuthenticationService do
  context 'hmac_authenticate' do
    it 'returns true if argument is a valid sha3 hmac token and the mode is sha3' do
      message = HmacAuthentication.sha3_hmac_token
      expect(AuthenticationService.hmac_authenticate(message, 'sha3')).to eql(true)
    end

    it 'returns true if argument is a valid openssl hmac token and the mode is openssl' do
      message = HmacAuthentication.openssl_hmac_token
      expect(AuthenticationService.hmac_authenticate(message, 'openssl')).to eql(true)
    end

    it 'raises AuthenticationException with message INVALID_HMAC_TOKEN if token is nil' do
       expect { AuthenticationService.hmac_authenticate(nil, 'sha3') }.to raise_error(AuthenticationException, HmacAuthentication::INVALID_HMAC_TOKEN)
    end

    it 'raises AuthenticationException with message INVALID_HMAC_TOKEN' do
       expect { AuthenticationService.hmac_authenticate('wrong token', 'openssl') }.to raise_error(AuthenticationException, HmacAuthentication::INVALID_HMAC_TOKEN)
    end

  end
end
