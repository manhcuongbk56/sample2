require 'base64'
require 'digest/sha3' # https://github.com/phusion/digest-sha3-ruby
require 'config_service'
require 'openssl'

class HmacAuthentication
  INVALID_HMAC_TOKEN = 'Invalid HMAC token.'
  class << self
    
    def load_config
      # ConfigService.environment will check RAILS_ENV, then RACK_ENV, then if none of them exists, use 'development' as default
      data = ConfigService.load_config('authentication.yml')[ConfigService.environment]
      raise StandardError.new("Secret for #{ConfigService.environment} environment is not set!") unless data

      @@secret_string    = data.secret_string
      @@hmac_key         = data.hmac_key
      data
    end

    def sha3_hexdigest(secret_string)
      # Generate 512-bit SHA-3 hexdigest
      Digest::SHA3.hexdigest(secret_string)
    end

    def sha3_hexdigest_eql?(plain_string, hashed_string)
      sha3_hexdigest(plain_string) == hashed_string
    end

    def openssl_sha_hexdigest(secret_string, secret_key)
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha512'), secret_key, secret_string)
    end

    def openssl_hexdigest_eql?(plain_string, hashed_string, secret_key)
      openssl_sha_hexdigest(plain_string, secret_key) == hashed_string
    end

    # Generate integer stamp that represent current time with accuracy to the minute
    # We don't want more accuracy to the second, because this time token is used for message authentication
    # Minute should be good enough for API clients to authenticate with API servers
    def generate_time_token(minus_minute)
      computed_time = Time.now - minus_minute.minute
      Time.parse(computed_time.strftime('%B-%d-%Y %H:%M %z')).to_i
    end

    # This method generates SHA-3 HMAC token for client to send to the server
    # to do SHA-3 HMAC authentication
    def sha3_hmac_token(minus_minute = 0)
      sha3_hexdigest(sent_message(minus_minute))
    end

    def validate_sha3_hmac_token(hashed_message)
      validate_token(hashed_message)
    end

    # This method generates HMAC token using OpenSSL SHA for client to send to the server
    # to do OpenSSL HMAC authentication
    def openssl_hmac_token(minus_minute = 0)
      openssl_sha_hexdigest(sent_message(minus_minute), @@hmac_key)
    end

    def validate_openssl_hmac_token(hashed_message)
      validate_token(hashed_message)
    end

    private

    def validate_token(hashed_message)
      caller_method = caller[0][/`.*'/][1..-2]
      return true if (self.send("#{caller_method.split('_')[1]}_hmac_token") == hashed_message)
      return true if (self.send("#{caller_method.split('_')[1]}_hmac_token", 1) == hashed_message)
      raise AuthenticationException.new(INVALID_HMAC_TOKEN)
    end

    def sent_message(minus_minute)
      "#{@@secret_string}|#{generate_time_token(minus_minute)}"
    end
  end

  load_config
end