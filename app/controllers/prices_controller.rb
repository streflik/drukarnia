class PricesController < ApplicationController
  before_filter :verify_admin
  
  def index
    @prices = Price.all
  end
  
  def show
    @price = Price.find(params[:id])
  end
  
  def new
    @price = Price.new
    @printtypes=Printtype.all
  end
  
  def create
    @price = Price.new(params[:price])
    if @price.save
      flash[:notice] = "Obiekt został pomyślnie dodany."
      redirect_to @price
    else
      render :action => 'new'
    end
  end
  
  def edit
    @price = Price.find(params[:id])
    @printtypes=Printtype.all
  end
  
  def update
    @price = Price.find(params[:id])
    if @price.update_attributes(params[:price])
      flash[:notice] = "Pomyślnie zaktualizowano obiekt."
      redirect_to @price
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @price = Price.find(params[:id])
    @price.destroy
    flash[:notice] = "Pomyślnie usunięto obiekt."
    redirect_to prices_url
  end
end
