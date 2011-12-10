require 'test_helper'

class PapersControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Paper.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Paper.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Paper.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to paper_url(assigns(:paper))
  end
  
  def test_edit
    get :edit, :id => Paper.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Paper.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Paper.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Paper.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Paper.first
    assert_redirected_to paper_url(assigns(:paper))
  end
  
  def test_destroy
    paper = Paper.first
    delete :destroy, :id => paper
    assert_redirected_to papers_url
    assert !Paper.exists?(paper.id)
  end
end
