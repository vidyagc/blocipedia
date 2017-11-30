class WikisController < ApplicationController
  
  before_action :authenticate_user!, except: [:index, :show]
 # before_action :check_permission, only: [:show]
  
  
  # def check_permission
  #   @wiki = Wiki.find(params[:id])
  #   if not @user #(@wiki.private == false || @wiki.user_id == current_user.id || current_user.role == 'admin')
  #     render status: :forbidden
  #   end
  # end
  
  def index
   @wikis = policy_scope(Wiki)
  end

  def show
    
      @wiki = Wiki.find(params[:id]) 

    rescue ActiveRecord::RecordNotFound
  redirect_to root_url, :flash => { :alert => "Record not found." }
    # if @user 
    #   if not (@wiki.private == false || @wiki.user_id == current_user.id || current_user.role == 'admin')
    #     render status: :forbidden
    #   end 
    # else 
    #   if @wiki.private == true
    #     render status: :forbidden
    #   end 
    # end 
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
      #redirect_to [@topic, @post]
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
 
    #authorize @wiki
    
    # if not params[:collab_email]==""
    #   collab_email = params[:collab_email]
    #   collab_user=User.find_by(email: collab_email)
    #   @wiki.collaborators.build(user: collab_user)
    # end 
    
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

def delete_image
  @wiki = Wiki.find(params[:id])
  @wiki.image.destroy #Will remove the attachment and save the model
  @wiki.save
  flash[:notice] = 'Wiki image photo has been removed.' 
  redirect_to @wiki

  #@user.avatar.clear #Will queue the attachment to be deleted
end
  
end
