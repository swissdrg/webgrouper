class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include WebgrouperPatientCasesHelper
  
  before_filter :set_locale

  def set_locale
     I18n.locale = params[:locale] || request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first rescue I18n.default_locale
  end
  
  def default_url_options(options={})
    { :locale => I18n.locale }
  end
  
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, with: lambda { |exception| render_error 404, exception }
  end

  private
  def render_error(status, exception)
    logger.warn exception
    respond_to do |format|
      format.html { render template: "errors/error_#{status}", layout: 'layouts/application', status: status }
      format.all { render nothing: true, status: status }
    end
  end
  
end
