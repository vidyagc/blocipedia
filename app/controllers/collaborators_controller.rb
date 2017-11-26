class CollaboratorsController < ApplicationController

   def create
     @wiki = Wiki.find(params[:wiki_id])
     collaborator = @wiki.collaborators.new(collab_params)
 
     if collaborator.save
       flash[:notice] = "Collaborator saved successfully."
       
       redirect_to wiki_path(@wiki)
     else
       flash[:alert] = "Collaborator failed to save."

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
 
   def collab_params
     params.require(:collaborator).permit(:emailid)
   end

end
