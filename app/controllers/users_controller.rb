class UsersController < ApplicationController
  before_filter :verify_admin, :only=>[:index]
  before_filter :verify_owner, :except=>[:index, :new]
  layout "application"

  def index
    @users = User.all
  end

  def show

    @orders=@user.orders
  end

  def new
    @user=User.new
    @user_login=User.new
    @order=params[:order_id]
  end

  def edit

  end

  def update

    if @user.update_attributes(params[:user])
      flash[:notice] = "Pomyślnie zaktualizowano dane."
      redirect_to @user
    else
      render :action => 'edit'
    end
  end

  def destroy

    @user.destroy
    flash[:notice] = "Pomyślnie usunięto konto użytkownika."
    redirect_to users_url
  end

    def change_password
    if request.put?
      if @user.update_with_password(params[:user])
        flash[:notice] = "Twoje hasło zostało zmienione."
        redirect_to @user
      else
        render :action => 'change_password'
      end
    end
  end

  protected
  def verify_owner
    @user=User.find params[:id]
    unless current_user && (current_user==@user || current_user.admin)
      flash[:error]="Nie masz uprawnień."
      redirect_to root_path
    else
      true
    end
  end


end
