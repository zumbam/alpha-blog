require 'test_helper'

class  CreateCategoriesTest < ActionDispatch::IntegrationTest

  test 'get new category form and create category' do
    get new_category_path
    assert_response :success
    assert_template 'categories/new'
    assert_difference 'Category.count' do
      post categories_path, params: {category: {name: 'sports'}}
      follow_redirect!
    end
    assert_template 'categories/index'
    assert_match 'sports', response.body

  end

end
