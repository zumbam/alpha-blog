require 'test_helper'

class  CreateCategoriesTest < ActionDispatch::IntegrationTest

  def setup
    @admin = User.create(username: "test", email: "test@example.com", password: "password", admin:true)
  end

  test 'get new category form and create category' do
    sign_in(email: @admin.email, password: @admin.password)
    get new_category_path
    assert_response :success
    assert_template 'categories/new'
    assert_difference 'Category.count' do
      post categories_path, params: {category: {name: 'sports'}}
      follow_redirect!
    end
    assert_template 'categories/index'
    assert_match 'sports'.downcase, response.body

  end

  test 'invalid category submission results in failure' do
    sign_in(email: @admin.email, password: @admin.password)
    get new_category_path
    assert_response :success
    assert_template 'categories/new'
    assert_no_difference 'Category.count' do
      post categories_path, params: {category: {name: ''}}
    end
    assert_template 'categories/new'
    assert_select 'div.alert-danger'
    assert_select 'h2.alert-heading'
    assert_select 'div.alert-body'

  end

end
