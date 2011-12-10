class SessionsController < ApplicationController
  prepend_before_filter :require_no_authentication, :only => [:new, :create]
  include Devise::Controllers::InternalHelpers
  layout "application"

  # GET /resource/sign_in
  def new
    unless flash[:notice].present?
      Devise::FLASH_MESSAGES.each do |message|
        set_now_flash_message :alert, message if params.try(:[], message) == "true"
      end
    end

    build_resource
    render_with_scope :new
  end

  # POST /resource/sign_in
  def create
    if resource = authenticate(resource_name)
      set_flash_message :notice, :signed_in
      if params[:order_id]
        sign_in(resource)
        redirect_to step_two_order_path(params[:order_id])
      else
        sign_in(resource)
        redirect_to resource
#        sign_in_and_redirect(resource_name, resource, true)
      end
    elsif [:custom, :redirect].include?(warden.result)
      throw :warden, :scope => resource_name
    else
      set_now_flash_message :alert, (warden.message || :invalid)
      clean_up_passwords(build_resource)
      if params[:order_id]
        @user_login=User.new
        @order=params[:order_id]
        render new_user_path, :layout=>"application"
      else
        render_with_scope :new
      end
    end
  end

  # GET /resource/sign_out
  def destroy
    set_flash_message :notice, :signed_out if signed_in?(resource_name)
    sign_out_and_redirect(resource_name)
  end

  protected

  def clean_up_passwords(object)
    object.clean_up_passwords if object.respond_to?(:clean_up_passwords)
  end
end
