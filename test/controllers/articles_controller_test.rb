# frozen_string_literal: true

require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @category = Category.create(name: 'sports')
    @admin = User.create(username: 'test', email: 'test@example.com', password: 'password', admin: true)
    @user = User.create(username: 'test1', email: 'test1@example.com', password: 'password', admin: false)
  end

  test 'redirect on new article without login' do
    get new_article_path
    assert_redirected_to root_path
  end

  test 'run new action article with login' do
    sign_in(email: @user.email, password: @user.password)
    get new_article_path
    assert_template 'new'
  end

  test 'redirect on create article with admin login' do
    sign_in(email: @admin.email, password: @admin.password)
    get new_article_path
    assert_template 'new'
  end

  test 'redirect if create article without login' do
    post articles_path, params: { article: { title: 'test',
                                             description: 'I am not allow to do this',
                                             categories: [@category] } }
    assert_redirected_to root_path
  end

  test 'create article as logged in user' do
    sign_in(email: @user.email, password: @user.password)

    params = { article: {
      title: 'test',
      description: 'I am allow to do this',
      category_ids: [@category.id]
    } }

    assert_difference 'Article.count' do
      post articles_path, params: params
    end

    a = Article.all.first
    assert_equal a.user, @user
    assert_equal a.title, params[:article][:title]
    assert_equal a.description, params[:article][:description]
    assert_equal a.categories, [@category]
  end

  test 'redirect on edit article without login' do
    a = create_test_article(user: @user, categories: [@category])
    get edit_article_path(a)
    assert_redirected_to root_path
  end

  test 'get edit template with login' do
    sign_in(email: @user.email, password: @user.password)
    a = create_test_article(user: @user, categories: [@category])
    get edit_article_path(a)
    assert_template 'edit'
    assert_response :success
  end

  test 'update article as logged in user and creator' do
    a = create_test_article(user: @user, categories: [@category])
    old_title = a.title
    sign_in(email: @user.email, password: @user.password)
    patch article_path(a), params: { article: { title: 'edit'} }
    assert_redirected_to article_path(a)
    a =  Article.all.first
    assert_equal 'edit', a.title
    assert_not_equal old_title, a.title
  end
end
