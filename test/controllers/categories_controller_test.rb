require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest

  def setup


    @category = Category.create(name: 'sports')
    @admin = User.create(username: "test", email: "test@example.com", password: "password", admin:true)
    @user = User.create(username: "test1", email: "test1@example.com", password: "password", admin:false)

  end

  test 'test index action' do
    get categories_path
    assert_response :success
  end

  test 'test new action' do
    # @user.password works only because of a setted value by creation
    # in find_by case this attribute does not exist
    sign_in(email:@admin.email, password:@admin.password)
    get new_category_path
    assert_response :success
  end

  test 'test show action' do
    get category_path(@category)
    assert_response :success
  end

  # controlling test for the edit action
  test 'redirect when create category and not logged in' do

    assert_no_difference 'Category.count' do
      post categories_path, params: {'category': {name: "food"}}
    end
    assert_redirected_to categories_path
  end

  test 'redirect when trying to edit category and not logged as admin' do
      sign_in(email: @user.email, password: @user.password)
      get edit_category_path(@category)
      assert_redirected_to categories_path
  end

  test 'redirect when trying to edit category and notlogged in' do
      get edit_category_path(@category)
      assert_redirected_to categories_path
  end

  # controlling test for the update function
  test 'update category and logged as admin' do
    sign_in(email: @admin.email, password: @admin.password)
    post categories_path(@category), params: {'category': {name: "food"}}
    assert_redirected_to categories_path
    assert_not_equal @category.name, "food"
  end


  test 'redirect when trying to update category and not logged in' do
    post categories_path(@category), params: {'category': {name: "food"}}
    assert_redirected_to categories_path
    assert_not_equal @category.name, "food"
  end

  test 'redirect when trying to update category and not logged as admin' do
    sign_in(email: @user.email, password: @user.password)
    post categories_path(@category), params: {'category': {name: "food"}}
    assert_redirected_to categories_path
    assert_not_equal @category.name, "food"
  end


end
