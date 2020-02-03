class CategoriesController < ApplicationController

  before_action :require_admin, except: [:index, :show]

  def index
    @categories = Category.paginate(page: params[:page], per_page: 5)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    successfully_created = @category.save
    if successfully_created
      flash[:success] = "The category has been successfully created"
      redirect_to categories_path
    else
      render :new
    end
  end

  def show
    @category = Category.find(params[:id])
    @category_articles = @category.articles.paginate(page: params[:page], per_page: 5)
  end

  private
  def category_params
    params.require(:category).permit([:name])
  end

  def require_admin
    if logged_in?
      if current_user.admin
        return
      else
        flash[:danger] = "You have to logged in as admin to perform this action"
      end

    else
      flash[:danger] = "You have to log in to perform a action"
    end

    redirect_to categories_path
  end



end
