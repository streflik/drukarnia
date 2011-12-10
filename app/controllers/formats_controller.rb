class FormatsController < ApplicationController
  before_filter :verify_admin
  def index
    @formats = Format.all
  end
  
  def show
    @format = Format.find(params[:id])
  end
  
  def new
    @format = Format.new
  end
  
  def create
    @format = Format.new(params[:format])
    if @format.save
      flash[:notice] = "Obiekt został pomyślnie dodany."
      redirect_to @format
    else
      render :action => 'new'
    end
  end
  
  def edit
    @format = Format.find(params[:id])
  end
  
  def update
    @format = Format.find(params[:id])
    if @format.update_attributes(params[:format])
      flash[:notice] = "Pomyślnie zaktualizowano obiekt."
      redirect_to @format
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @format = Format.find(params[:id])
    @format.destroy
    flash[:notice] = "Pomyślnie usunięto obiekt."
    redirect_to formats_url
  end
end
