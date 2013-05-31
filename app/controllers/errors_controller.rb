class ErrorsController < ApplicationController
  def error_404
    @not_found_path = params[:not_found]
    render 'error_404', :status => 404
  end

  def error_500
    render 'error_500', :status => 500
  end
end