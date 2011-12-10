class OptionsController < ApplicationController
  before_filter :verify_admin
  
  def index
    @options = Option.all
  end
  
  def show
    @option = Option.find(params[:id])
  end
  
  def new
    @option = Option.new
    @option.printtypes.build
  end
  
  def create
    @option = Option.new(params[:option])
    if @option.save
      flash[:notice] = "Obiekt został pomyślnie dodany."
      redirect_to @option
    else
      render :action => 'new'
    end
  end
  
  def edit
    @option = Option.find(params[:id])
  end
  
  def update
    @option = Option.find(params[:id])
    if @option.update_attributes(params[:option])
      flash[:notice] = "Pomyślnie zaktualizowano obiekt."
      redirect_to @option
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @option = Option.find(params[:id])
    @option.destroy
    flash[:notice] = "Pomyślnie usunięto obiekt."
    redirect_to options_url
  end
end
