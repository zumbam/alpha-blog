class UsersController < ApplicationController

before_action :set_user, only: [:edit, :show, :update, :destroy]
before_action :require_same_user, only: [:edit, :update]
before_action :require_admin, only: [:destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
  end

  def show
  end


  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to Alpha-Blog #{@user.username}"
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def update
    successfully_updated = @user.update(user_params)
    if successfully_updated
      flash[:success] = 'Your accout has successfully updated'
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    successfully_deleted = @user.destroy
    if successfully_deleted
      flash[:success] = "User successfully deleted with all it's articles"
    end
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if !(logged_in? && (current_user == @user || current_user.admin))
      flash[:danger] = "You have no permission to do this action"
      redirect_to root_path
    end
  end

  def require_admin
    if logged_in? && !current_user.admin
      flash[:danger] = "Only admin can delete users"
      redirect_to root_path
    end
  end

end
