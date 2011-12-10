class PrinttypesController < ApplicationController
  before_filter :verify_admin
  
  def index
    @printtypes = Printtype.all
  end
  
  def show
    @printtype = Printtype.find(params[:id])
  end
  
  def new
    @printtype = Printtype.new
  end
  
  def create
    @printtype = Printtype.new(params[:printtype])
    if @printtype.save
      flash[:notice] = "Obiekt został pomyślnie dodany."
      redirect_to @printtype
    else
      render :action => 'new'
    end
  end
  
  def edit
    @printtype = Printtype.find(params[:id])
  end
  
  def update
    @printtype = Printtype.find(params[:id])
    if @printtype.update_attributes(params[:printtype])
      flash[:notice] = "Pomyślnie zaktualizowano obiekt."
      redirect_to @printtype
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @printtype = Printtype.find(params[:id])
    @printtype.destroy
    flash[:notice] = "Pomyślnie usunięto obiekt."
    redirect_to printtypes_url
  end
end
