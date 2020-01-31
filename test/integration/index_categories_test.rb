require 'test_helper'

class IndexCategoriesTest < ActionDispatch::IntegrationTest

  def setup
    @category1 = Category.create(name: 'sports')
    @category2 = Category.create(name: 'livestyle')
  end

  test 'create categories and list them on the categories page' do
    get categories_path
    assert_response :success
    assert_select 'a[href=?]', category_path(@category1), text: @category1.name
    assert_select 'a[href=?]', category_path(@category2), text: @category2.name
  end
end
