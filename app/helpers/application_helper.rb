# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper


 def admin?
   if current_user && current_user.id==1
     true
   else
     false    
   end
 end

end
