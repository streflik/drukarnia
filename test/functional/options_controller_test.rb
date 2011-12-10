require 'test_helper'

class OptionsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Option.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Option.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Option.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to option_url(assigns(:option))
  end
  
  def test_edit
    get :edit, :id => Option.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Option.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Option.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Option.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Option.first
    assert_redirected_to option_url(assigns(:option))
  end
  
  def test_destroy
    option = Option.first
    delete :destroy, :id => option
    assert_redirected_to options_url
    assert !Option.exists?(option.id)
  end
end
