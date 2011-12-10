require 'test_helper'

class PrinttypesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Printtype.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Printtype.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Printtype.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to printtype_url(assigns(:printtype))
  end
  
  def test_edit
    get :edit, :id => Printtype.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Printtype.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Printtype.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Printtype.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Printtype.first
    assert_redirected_to printtype_url(assigns(:printtype))
  end
  
  def test_destroy
    printtype = Printtype.first
    delete :destroy, :id => printtype
    assert_redirected_to printtypes_url
    assert !Printtype.exists?(printtype.id)
  end
end
