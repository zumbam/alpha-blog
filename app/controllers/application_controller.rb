class ApplicationController < ActionController::Base

  helper_method :current_user, :logged_in?, :logged_in_as_admin?, :logged_in_as_same_user_or_admin?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:danger] = "Your have to be logged in to perform this request"
      redirect_to root_path
    end
  end

  def logged_in_as_admin?
    logged_in? && @current_user.admin
  end

  def logged_in_as_same_user_or_admin?(user)
    logged_in? && (@current_user == user || @current_user.admin)
  end

end
