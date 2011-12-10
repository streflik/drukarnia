class RegistrationsController < ApplicationController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy]
  include Devise::Controllers::InternalHelpers
  layout "application"

  # GET /resource/sign_in
  def new
    build_resource
    render_with_scope :new
  end

  # POST /resource/sign_up
  def create
    params[:user]=params[:user_reg] if params[:user_reg]
    build_resource

    if resource.save
      set_flash_message :notice, :signed_up

      if params[:order_id]
        sign_in(resource)
        redirect_to step_two_order_path(params[:order_id])
      else
        sign_in(resource)
        sign_in_and_redirect(resource_name, resource, true)
      end
    else
      if params[:order_id]
        @user=resource
        @order=params[:order_id]
        render new_user_path, :layout=>"application"
      else
        render_with_scope :new
      end
    end
  end

  # GET /resource/edit
  def edit
    render_with_scope :edit
  end

  # PUT /resource
  def update
    if self.resource.update_with_password(params[resource_name])
      set_flash_message :notice, :updated
      redirect_to after_sign_in_path_for(self.resource)
    else
      render_with_scope :edit
    end
  end

  # DELETE /resource
  def destroy
    self.resource.destroy
    set_flash_message :notice, :destroyed
    sign_out_and_redirect(self.resource)
  end

  protected

  # Authenticates the current scope and dup the resource
  def authenticate_scope!
    send(:"authenticate_#{resource_name}!")
    self.resource = send(:"current_#{resource_name}").dup
  end
end