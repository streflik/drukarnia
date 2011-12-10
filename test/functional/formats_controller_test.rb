require 'test_helper'

class FormatsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Format.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Format.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Format.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to format_url(assigns(:format))
  end
  
  def test_edit
    get :edit, :id => Format.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Format.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Format.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Format.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Format.first
    assert_redirected_to format_url(assigns(:format))
  end
  
  def test_destroy
    format = Format.first
    delete :destroy, :id => format
    assert_redirected_to formats_url
    assert !Format.exists?(format.id)
  end
end
