require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @category = Category.new(name: 'sports')
    s = @category.save
    puts @category.errors.full_messages
    puts @category.id
  end

  test 'test index action' do
    get categories_path
    assert_response :success
  end

  test 'test new action' do
    get new_category_path
    assert_response :success
  end



  test 'test show action' do
    get category_path(@category)
    assert_response :success
  end
end
