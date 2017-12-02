class WikisController < ApplicationController
  
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_permission, only: [:show]
  
  
  def check_permission
    @wiki = Wiki.find(params[:id])
    if current_user 
      if not (@wiki.private == false || @wiki.user_id == current_user.id || current_user.role == 'admin' || @wiki.collaborators.where(:emailid => current_user.email))
        raise Pundit::NotAuthorizedError
      end
    else 
      if not (@wiki.private == false)
        raise Pundit::NotAuthorizedError
      end 
    end 
    
  end
  
  def index
   @wikis = policy_scope(Wiki)
  end

  def show
    
      @wiki = Wiki.find(params[:id]) #policy_scope(Wiki.find(params[:id])), undefined method `all' for #<Wiki:0x007fae02556768>, else #if user.role =='standard' # this is the lowly standard user
         #all_wikis = scope.all

    rescue ActiveRecord::RecordNotFound
  redirect_to root_url, :flash => { :alert => "Record not found." }

  end

  def new
    @wiki = Wiki.new
  end

  def create
    @wiki = Wiki.new
    @wiki.title = params[:wiki][:title]
    @wiki.body = params[:wiki][:body]
    @wiki.image = params[:wiki][:image]
    @wiki.private = params[:wiki][:private]
    @wiki.user = current_user
    
    if @wiki.save
      flash[:notice] = "Wiki was saved."
      redirect_to @wiki
     else
       flash.now[:alert] = "There was an error saving the wiki. Please try again."
       render :new
     end
  end

  def edit
    @wiki = Wiki.find(params[:id])
  end

  def update
    @wiki = Wiki.find(params[:id])
    @wiki.title = params[:wiki][:title]
    @wiki.body = params[:wiki][:body]
    @wiki.image = params[:wiki][:image] unless params[:wiki][:image].nil?
    @wiki.remove_image = params[:wiki][:remove_image]
    
    if @wiki.save
     flash[:notice] = "Wiki was updated."
       redirect_to @wiki
    else
     flash.now[:alert] = "There was an error saving the wiki. Please try again."
       render :edit
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])
    
    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to users_show_path
     else
      flash.now[:alert] = "There was an error deleting the wiki."
      render :show
    end
  end

# def delete_image
#   @wiki = Wiki.find(params[:id])
#   @wiki.image.destroy #Will remove the attachment and save the model
#   @wiki.save
#   flash[:notice] = 'Wiki image photo has been removed.' 
#   render :edit
# end
  
end
