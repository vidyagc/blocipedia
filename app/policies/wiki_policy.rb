class WikiPolicy < ApplicationPolicy

    class Scope
        attr_reader :user, :scope
      
        def initialize(user, scope)
            @user = user
            @scope = scope
        end
      
        def resolve
            wikis = []
            collab=false
          
            if user
                if user.role == 'admin'
                    wikis = scope.all 
                elsif user.role == 'premium'
                    all_wikis = scope.all 
                    all_wikis.each do |wiki|
                        wiki.collaborators.each do |collaborator|
                            if user.email == collaborator.emailid
                                collab=true
                            end
                        end 
                        
                        if wiki.private == false || wiki.user == user 
                            wikis << wiki 
                        end
                    end
                else  
                    all_wikis = scope.all
                    wikis = []
                
                    all_wikis.each do |wiki|
                        wiki.collaborators.each do |collaborator|
                            if user.email == collaborator.emailid
                                collab=true
                            end
                        end 
                
                        if wiki.private == false  || wiki.user == user || collab==true 
                            wikis << wiki 
                        end
                    end
                end 
            else 
                all_wikis = scope.all
                wikis = []
                all_wikis.each do |wiki|
                    if wiki.private == false
                        wikis << wiki 
                    end
                end
            end
            wikis # return the wikis array that's built up
        end

    end
end