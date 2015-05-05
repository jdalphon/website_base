class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include DeviseHelper
  
  before_filter :set_namespace
  
  def set_namespace
    @namespace = { action: params[:action], controller: params[:controller] }
  end
  
end
