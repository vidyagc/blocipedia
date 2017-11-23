class CollaboratorsController < ApplicationController

   def create
 # #11
     @wiki = Wiki.find(params[:wiki_id])
     collaborator = @wiki.collaborators.new(collab_params)
     #comment.user = current_user
 
     if collaborator.save
       flash[:notice] = "Collaborator saved successfully."
 # #12
       redirect_to wiki_path(@wiki)
     else
       flash[:alert] = "Collaborator failed to save."
 # #13
       redirect_to wiki_path(@wiki)
     end
   end
 
   def destroy
     @wiki = Wiki.find(params[:wiki_id])
     collaborator = @wiki.collaborators.find(params[:id])
 
     if collaborator.destroy
       flash[:notice] = "Collaborator was deleted."
       redirect_to wiki_path(@wiki)
     else
       flash[:alert] = "Collaborator couldn't be deleted. Try again."
       redirect_to wiki_path(@wiki)
     end
   end
 
   private
 
 # #14
   def collab_params
     params.require(:collaborator).permit(:emailid)
   end

end
