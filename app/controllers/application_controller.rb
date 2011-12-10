# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
   filter_parameter_logging :password

  def verify_admin
     if is_admin?
     true
   else

     redirect_to root_path, :alert=> "Nie masz uprawnień."
   end
  end

  def is_admin?
      current_user && current_user.id==1
  end

end
