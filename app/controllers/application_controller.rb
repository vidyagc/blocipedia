class ApplicationController < ActionController::Base

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
  
  
  private
  
  def user_not_authorized
    redirect_to root_url, :flash => { :alert => "You do not have access to this wiki" } 
  end
  
end
