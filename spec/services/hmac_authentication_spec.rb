require 'rails_helper'
describe HmacAuthentication do
  before :all do
    config = HmacAuthentication.load_config
    @secret_string = config.secret_string
    @hmac_key      = config.hmac_key
  end


  context 'load_config' do
    it 'loads the secret string from yml file' do
      config = HmacAuthentication.load_config
      expect(config.secret_string).to eql('49ce67ad33c43093be451f2be9346a045e524ce86a052837ba33d8205ad86010b09b04b00ae91fc6e4e823017e568020d468cc25f2c7dad8de4b709db196297f')
      expect(config.hmac_key).to eql('eda765576c84c600ed7f5d97510e92703b61f5215def2a161037fd9dd1f5b6ed4f86ce46073c0e3f34b52de0289e9c618798fff9dd4b1bfe035bdb8645fc6e37')
    end

    it 'raises error Secret Not Found if the secret for an environment is not set' do
      Rails.env = 'strange'
      expect { HmacAuthentication.load_config }.to raise_error(StandardError, 'Secret for strange environment is not set!')
      Rails.env = 'test'
    end
  end

  context 'sha3_hexdigest' do
    it 'generates sha3 hexdigest for a string' do
      plain_string = 'Here is a secret string'
      digest_string = HmacAuthentication.sha3_hexdigest(plain_string)
      expect(digest_string).not_to be_nil
      expect(digest_string).not_to eql(plain_string)
    end
  end

  context 'sha3_hexdigest_eql?' do
    it 'returns true if plain string has hexdigest that equals hashed string' do
      plain_string  = 'Hello, World!'
      hashed_string = HmacAuthentication.sha3_hexdigest(plain_string)
      expect(HmacAuthentication.sha3_hexdigest_eql?(plain_string, hashed_string)).to be true
    end

    it 'returns false if plain string has hexdigest that does not equal hashed string' do
      plain_string  = 'Hello, World!'
      hashed_string = HmacAuthentication.sha3_hexdigest('Some thing else')
      expect(HmacAuthentication.sha3_hexdigest_eql?(plain_string, hashed_string)).to be false
    end

  end

  context 'openssl_sha_hexdigest' do
    it 'generates hexdigest for a string using OpenSSL SHA' do
      plain_string = 'Here is a secret string'
      digest_string = HmacAuthentication.openssl_sha_hexdigest(plain_string, 'Here is a secret key')
      expect(digest_string).not_to be_nil
      expect(digest_string).not_to eql(plain_string)
    end
  end

  context 'openssl_hexdigest_eql?' do
    before :all do
      @plain_string  = 'Hello, World!'
      @secret_key    = 'Here is a secret key'
    end

    it 'returns true if plain string has hexdigest that equals hashed string' do
      hashed_string = HmacAuthentication.openssl_sha_hexdigest(@plain_string, @secret_key)
      expect(HmacAuthentication.openssl_hexdigest_eql?(@plain_string, hashed_string, @secret_key)).to be true
    end

    it 'returns false if plain string has hexdigest that does not equal hashed string' do
      hashed_string = HmacAuthentication.openssl_sha_hexdigest('Some thing else', @secret_key)
      expect(HmacAuthentication.openssl_hexdigest_eql?(@plain_string, hashed_string, @secret_key)).to be false
    end
  end

  context 'generate_time_token' do
    it 'generates a timestamp with current month, day, year, hour, minute, but the second is 0' do
      current_time = Time.now
      time_token = HmacAuthentication.generate_time_token(0)
      timestamp = Time.at(time_token)
      %w(month day year hour min).each do |attr|
        expect(current_time.send(attr)).to eql(timestamp.send(attr))
      end

      expect(timestamp.sec).to eql(0)

    end

    it 'generates a timestamp with the minute is the current minute - minus_minute' do
      current_time = Time.now
      time_token = HmacAuthentication.generate_time_token(1)
      timestamp = Time.at(time_token)
      %w(month day year hour).each do |attr|
        expect(current_time.send(attr)).to eql(timestamp.send(attr))
      end

      expect(timestamp.min).to eql(current_time.min - 1)
      expect(timestamp.sec).to eql(0)

    end
  end

  context 'sha3_hmac_token' do
    it 'generates SHA-3 HMAC token' do
      token = HmacAuthentication.sha3_hmac_token
      expect(token).not_to be nil
    end
  end

  context 'validate_sha3_hmac_token' do
    it 'returns true if the hashed message is valid' do
      time_token = HmacAuthentication.generate_time_token(0)
      message = "#{@secret_string}|#{time_token}"
      hashed_message = HmacAuthentication.sha3_hexdigest(message)

      expect(HmacAuthentication.validate_sha3_hmac_token(hashed_message)).to be true
    end

    it 'raises AuthenticationException if the hashed_message is not valid' do
      hashed_message = 'I am a hacker.'
      expect { HmacAuthentication.validate_sha3_hmac_token(hashed_message) }.to raise_error(AuthenticationException, HmacAuthentication::INVALID_HMAC_TOKEN)
    end

  end

  context 'openssl_hmac_token' do
    it 'generates HMAC token using OpenSSL SHA' do
      token = HmacAuthentication.openssl_hmac_token
      expect(token).not_to be nil
    end
  end

  context 'validate_openssl_hmac_token' do
    it 'returns true if the hashed message is valid' do
      time_token = HmacAuthentication.generate_time_token(0)
      message = "#{@secret_string}|#{time_token}"
      hashed_message = HmacAuthentication.openssl_sha_hexdigest(message, @hmac_key)

      expect(HmacAuthentication.validate_openssl_hmac_token(hashed_message)).to be true
    end

    it 'raises AuthenticationException if the hashed_message is not valid' do
      hashed_message = 'I am a hacker.'
      expect { HmacAuthentication.validate_openssl_hmac_token(hashed_message) }.to raise_error(AuthenticationException, HmacAuthentication::INVALID_HMAC_TOKEN)
    end
  end

end