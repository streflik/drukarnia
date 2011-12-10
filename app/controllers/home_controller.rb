class HomeController < ApplicationController
  before_filter :verify_admin, :only=>:admin
  def index
    @updates = Update.all
    @promotions = Update.all(:conditions => {:is_promotion => true})
  end

  def contact

  end

  def admin

  end

end
