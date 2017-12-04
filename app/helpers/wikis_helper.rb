module WikisHelper
    
   def user_is_authorized_for_collaborator?(wiki)
      current_user && current_user == wiki.user && wiki.private==true
   end
    
end
