class ApplicationController < ActionController::Base

  before_action :set_theme

  def set_theme
    if params[:theme].present?
      theme = params[:theme].to_sym
      session[:theme] = theme
      redirect_to(request.referrer || root_path)
    end
  end
  
  def lookup_ip_location
    if Rails.env.development?
      location = Geocoder.search(request.remote_ip).first
    else
      request.location
    end
  end
  
end
