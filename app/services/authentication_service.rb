class AuthenticationService
  
  class << self
    def hmac_authenticate(token, mode = 'sha3')
      HmacAuthentication.send("validate_#{mode}_hmac_token", token) 
    end

  end
end