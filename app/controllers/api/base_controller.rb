class Api::BaseController < ApplicationController

  # Don't do regular CSRF protection over the json API, rather just ignore the entire session
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  before_filter :authenticate_user_from_token!

  def default_url_options
    { :host => Rails.application.config.default_host }
  end

  def authenticate_user_from_token!
    api_key = ApiKey.find_by_client_id!(params[:client_id])
    sign_in api_key.user, store: false
    # TODO HMAC
  end
end
