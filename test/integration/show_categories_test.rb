require 'test_helper'

class ShowCategoriesTest < ActionDispatch::IntegrationTest
  def setup
    # setting up 5 articles of the same category to show pagination
    @user = User.create(username: 'test', email: 'test@example.com', password: 'password', admin:false)
    @test_category = Category.create(name: 'sports')
    @test_articles_ids = 1..5
    @test_articles_ids.each do |id|
      Article.create(title: "test #{id}", description: "automatic test #{id} description",user: @user, categories: [@test_category])
    end
  end

  test 'show paginagtion for an article category' do
      # for a page with more then 5 articles pagination shout be shown
    Article.create(title: 'test 6', description: 'automatic test 6 description',user: @user, categories: [@test_category])
    get category_path(@test_category)
    assert_response :success
    assert_template 'categories/show'
    assert @test_category.articles.count > 5
    assert_select 'ul.pagination'

  end

  test 'don\'t show pagination under 5 items' do
    # for a page with less then 5 articles no pagination shout be shown
    get category_path(@test_category)
    assert_response :success
    assert_template 'categories/show'
    assert @test_category.articles.count == 5
    assert_select 'ul.pagination', false
  end


  test 'display correct articles for category' do
    # this test add 3 articles for 3 different articles and test the displaying
    # of correct badge in the ideviduell show page to insure correct
    # article selection
    category_strs = %w[food politics livestyle]
    @categories = Array.new
    category_strs.each do |c|
      category = Category.create(name: c)
      @categories << category
      Article.create(title: "article about #{c}", description: "description about #{c}", user: @user, categories: [category])
    end

    # check count category labels in sport case (page max 5)
    get category_path(@test_category)
    assert_response :success
    assert_select 'span.badge', {count: 5, text: @test_category.name}
    assert_select 'span.badge', {count: 0, text: @categories[0].name}
    assert_select 'span.badge', {count: 0, text: @categories[1].name}
    assert_select 'span.badge', {count: 0, text: @categories[2].name}

    # check count category labels in food case
    get category_path(@categories[0])
    assert_response :success
    assert_select 'span.badge', {count: 0, text: @test_category.name}
    assert_select 'span.badge', {count: 1, text: @categories[0].name}
    assert_select 'span.badge', {count: 0, text: @categories[1].name}
    assert_select 'span.badge', {count: 0, text: @categories[2].name}

    # check count category labels in politics case
    get category_path(@categories[1])
    assert_response :success
    assert_select 'span.badge', {count: 0, text: @test_category.name}
    assert_select 'span.badge', {count: 0, text: @categories[0].name}
    assert_select 'span.badge', {count: 1, text: @categories[1].name}
    assert_select 'span.badge', {count: 0, text: @categories[2].name}

    # check count category labels in livestyle case
    get category_path(@categories[2])
    assert_response :success
    assert_select 'span.badge', {count: 0, text: @test_category.name}
    assert_select 'span.badge', {count: 0, text: @categories[0].name}
    assert_select 'span.badge', {count: 0, text: @categories[1].name}
    assert_select 'span.badge', {count: 1, text: @categories[2].name}


  end


end
