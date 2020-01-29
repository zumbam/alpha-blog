class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
  end


  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to Alpha-Blog #{@user.username}"
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
    successfully_updated = @user.update(user_params)
    if successfully_updated
      flash[:success] = 'Your accout has successfully updated'
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

end
