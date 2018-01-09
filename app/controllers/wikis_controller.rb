class WikisController < ApplicationController
  
  before_action :authenticate_user!, except: [:index, :show] 
  before_action :check_permission, except: [:index, :new, :create]
  
  def index
    @wikis = policy_scope(Wiki)
  end

  def show
    @wiki = Wiki.find(params[:id]) 
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
      # flash.now[:alert] = "There was an error saving the wiki. Please try again."
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
  
private

  def check_permission
    @wiki = Wiki.find(params[:id])
    if current_user 
      if not (@wiki.private == false || @wiki.user_id == current_user.id || current_user.role == 'admin' || @wiki.collaborators.where(emailid: current_user.email).length == 1)
        redirect_to root_url, :flash => { :alert => "You do not have access to this wiki" }
      end
    else 
      if not (@wiki.private == false)
        redirect_to root_url, :flash => { :alert => "You do not have access to this wiki" }
      end 
    end 
  end
  
end
