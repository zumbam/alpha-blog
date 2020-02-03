require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create(username: "test1", email: "test1@example.com", password: "password", admin:false)
    @user1 = User.create(username: "test2", email: "test2@example.com", password: "password", admin:false)
  end

  test 'login user' do
    post login_path, params: {session: {email: @user.email, password: @user.password}}
    assert_redirected_to user_path(@user)
  end

  test 'redirect in case of wrong password' do
    post login_path, params: {session: {email: @user.email, password: ''}}
    assert_template 'new'
  end

  test 'redirect in case of wrong email' do
    post login_path, params: {session: {email: "t@example.com", password: @user.password}}
    assert_template 'new'
  end

  test 'login after already a user logged in' do
    post login_path, params: {session: {email: @user.email, password: @user.password}}
    assert_redirected_to user_path(@user)
    post login_path, params: {session: {email: @user1.email, password: @user1.password}}
    assert_redirected_to user_path(@user1)
    assert_equal @user1.id, session[:user_id]
  end

  test 'logout a user' do
    post login_path, params: {session: {email: @user.email, password: @user.password}}
    assert_redirected_to user_path(@user)
    delete logout_path
    assert_not session[:user_id]
  end
end
