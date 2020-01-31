require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest

  def setup


    @category = Category.create(name: 'sports')
    @user = User.create(username: "test", email: "test@example.com", password: "password", admin:true)

  end

  test 'test index action' do
    get categories_path
    assert_response :success
  end

  test 'test new action' do
    # @user.password works only because of a setted value by creation
    # in find_by case this attribute does not exist
    sign_in(email:@user.email, password:@user.password)
    get new_category_path
    assert_response :success
  end

  test 'test show action' do
    get category_path(@category)
    assert_response :success
  end


  test 'redirect when create category and not logged in' do

    assert_no_difference 'Category.count' do
      post categories_path, params: {'category': {name: "sports"}}
    end
    assert_redirected_to categories_path
  end


end
