class OrdersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only =>:new_image
  before_filter :verify_admin, :only=>[:index,:edit,:update,:destroy]
  before_filter :verify_owner, :only=>[:show]

  def index
    @orders = Order.all
  end

  def show

  end

  def new
    @order = Order.new
    @printtype=Printtype.find params[:printtype]
  end

  def create
    @order = Order.new(params[:order])
    @printtype=Printtype.find params[:order][:printtype_id]
    if @order.save

      if user_signed_in?
        redirect_to step_two_order_path(@order)
      else
        redirect_to new_user_path(:order_id=>@order.id)
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @order = Order.find(params[:id])
    @printtype=@order.printtype
  end

  def update
    @order = Order.find(params[:id])
    if @order.update_attributes(params[:order])
      flash[:notice] = "Pomyślnie zaktualizowano zamówienie."
      redirect_to @order
    else
      render :action => 'edit'
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    flash[:notice] = "Pomyślnie usunięto zamówienie."
    redirect_to orders_url
  end

  def step_two
    @order=Order.find params[:id]
    @user= current_user || {}
    if request.put?
      params[:order][:user_id]=current_user.id if current_user
      if @order.update_attributes(params[:order])
        Mailer::deliver_new_order(@order)
        flash[:notice] = "Pomyślnie utworzono zamówienie."
        render :action=>:show_once
      else
        render :action => 'step_two'
      end
    end
  end

  def show_once
    
  end

  def new_image
    @image = Image.new(:swfupload_file => params[:Filedata])
    @image.save
    render :nothing => true
  end

  private
  def verify_owner
     @order = Order.find(params[:id])
   if is_admin? || (@order.user && @order.user.id==current_user.id)
     true
       else
      redirect_to root_path, :alert=> "Nie masz uprawnień."
   end
   end
  
end
