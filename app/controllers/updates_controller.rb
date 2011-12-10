class UpdatesController < ApplicationController
  before_filter :verify_admin, :except=>[:index,:show]


  def index
    @updates = Update.all

  end
  
  def show
    @update = Update.find(params[:id])
  end
  
  def new
    @update = Update.new
  end
  
  def create
    @update = Update.new(params[:update])
    if @update.save
      flash[:notice] = "Pomyślnie dodano nową aktualność."
      redirect_to @update
    else
      render :action => 'new'
    end
  end
  
  def edit
    @update = Update.find(params[:id])
  end
  
  def update
    @update = Update.find(params[:id])
    if @update.update_attributes(params[:update])
      flash[:notice] = "Pomyślnie zaktualizowano aktualność."
      redirect_to @update
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @update = Update.find(params[:id])
    @update.destroy
    flash[:notice] = "Pomyślnie usunięto aktualność."
    redirect_to updates_url
  end
end
