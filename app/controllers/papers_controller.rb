class PapersController < ApplicationController
  before_filter :verify_admin
  
  def index
    @papers = Paper.all
  end
  
  def show
    @paper = Paper.find(params[:id])
  end
  
  def new
    @paper = Paper.new
  end
  
  def create
    @paper = Paper.new(params[:paper])
    if @paper.save
      flash[:notice] = "Obiekt został pomyślnie dodany."
      redirect_to @paper
    else
      render :action => 'new'
    end
  end
  
  def edit
    @paper = Paper.find(params[:id])
  end
  
  def update
    @paper = Paper.find(params[:id])
    if @paper.update_attributes(params[:paper])
      flash[:notice] = "Pomyślnie zaktualizowano obiekt."
      redirect_to @paper
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @paper = Paper.find(params[:id])
    @paper.destroy
    flash[:notice] = "Pomyślnie usunięto obiekt."
    redirect_to papers_url
  end
end
