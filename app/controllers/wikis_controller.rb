class WikisController < ApplicationController
  
  before_action :authenticate_user!, except: [:index, :show]
  
  def check_permission
    @wiki = Wiki.find(params[:id])
    if not (@wiki.private == false || @wiki.user_id == current_user.id || current_user.role == 'admin')
      render status: :forbidden
    # if @wiki.private == false || @wiki.user_id == current_user.id || current_user.role == 'admin'
    #   super
    # else 
    # flash[:error] = 'You are not allowed to perform this function on this Wiki'
   end
  end
  
  def index
    @wikis = Wiki.all
  end

  def show
    @wiki = Wiki.find(params[:id])
  end

  def new
    @wiki = Wiki.new
  end

  def create
    @wiki = Wiki.new
    @wiki.title = params[:wiki][:title]
    @wiki.body = params[:wiki][:body]
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
 
    #authorize @wiki
 
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
  
end
