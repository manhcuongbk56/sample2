class ApplicationController < ActionController::Base
  ACCESS_FORBIDDEN = 'Acccess forbidden.'
  ERROR_ACCEPT_CONSENT_FORM = 'Error during accepting consent form.'
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  # This method is tested by all the sub controllers, so there is no need to have unit test for this.
  def process_request(error_message)
    yield
  rescue ObjectNotFoundException => onfe
    render json: { errors: onfe.message }, status: :not_found
  rescue ActiveRecord::RecordNotFound => rnf
    render json: { errors: rnf.message }, status: :not_found
  rescue StandardError => exc
    @error = exc
    Rails.logger.error("Error: #{exc.message}\n#{exc.backtrace.join("\n")}")
    render json: { errors: error_message }, status: :internal_server_error
  end

  private

  def authentication
    AuthenticationService.hmac_authenticate(request.headers['api-token'], 'sha3')
  rescue AuthenticationException => auth_exception
    Rails.logger.error("Error: #{auth_exception.message}\n#{auth_exception.backtrace.join("\n")}")
    render json: { error: ACCESS_FORBIDDEN }, status: :forbidden
  end
end
