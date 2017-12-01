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
         wikis = scope.all # if the user is an admin, show them all the wikis
      elsif user.role == 'premium'
         all_wikis = scope.all 
         all_wikis.each do |wiki|
             wiki.collaborators.each do |collaborator|
                 if user.email == collaborator.emailid
                     collab=true
                 end
             end 
             # put loop for checking collaborators (inside check for each Wiki - wiki.collaborators.each do - collaborator.email == user.email, then collab = true)
          if wiki.private == false || wiki.user == user #|| user.email=="vidyagc15@gmail.com" # collab==true #|| wiki.collaborators.include?(user)
             wikis << wiki # if the user is premium, only show them public wikis, or that private wikis they created, or private wikis they are a collaborator on
          end
         end
      else #if user.role =='standard' 
         all_wikis = scope.all
         wikis = []
  
         all_wikis.each do |wiki|
             wiki.collaborators.each do |collaborator|
                 if user.email == collaborator.emailid
                     collab=true
                 end
             end 
          if wiki.private == false  || wiki.user == user || collab==true #|| user.email=="vidyagc15@gmail.com" #|| wiki.collaborators.include?(user)
             wikis << wiki # only show standard users public wikis and private wikis they are a collaborator on
          end
         end
      end 
    else # this is the lowly standard user
         all_wikis = scope.all
         wikis = []
         all_wikis.each do |wiki|
          if wiki.private == false
             wikis << wiki # only show standard users public wikis and private wikis they are a collaborator on
          end
         end
      end
      wikis # return the wikis array that's built up
     end

    def update?
        record.user == user
    end
  end
end