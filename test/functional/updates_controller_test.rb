require 'test_helper'

class UpdatesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Update.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Update.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Update.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to update_url(assigns(:update))
  end
  
  def test_edit
    get :edit, :id => Update.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Update.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Update.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Update.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Update.first
    assert_redirected_to update_url(assigns(:update))
  end
  
  def test_destroy
    update = Update.first
    delete :destroy, :id => update
    assert_redirected_to updates_url
    assert !Update.exists?(update.id)
  end
end
