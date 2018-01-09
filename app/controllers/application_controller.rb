class ApplicationController < ActionController::Base
helper_method :resource_name, :resource, :devise_mapping, :resource_class
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  
  def after_sign_in_path_for(resource)
    if resource.class == User
      users_show_path
    end 
  end
  
# start resource mapping
# https://pupeno.com/2010/08/29/show-a-devise-log-in-form-in-another-page/

  def new
  end
 
  private
 
  def resource_name
    :user
  end
  helper_method :resource_name
 
  def resource
    @resource ||= User.new
  end
  helper_method :resource
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  helper_method :devise_mapping
 
  def resource_class
    User
  end
  helper_method :resource_class
  
# end resource mapping
  
  private
  
  def user_not_authorized
    redirect_to root_url, :flash => { :alert => "You do not have access to this wiki" } 
  end
  
end


