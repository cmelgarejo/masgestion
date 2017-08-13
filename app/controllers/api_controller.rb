class ApiController < ActionController::API
  include Response
  include ExceptionHandler
  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: I18n.t('api.not_authorized') }, status: 401 unless @current_user
  end
end
