class CategoriesController < ApplicationController

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
  end

  private
  def category_params
    params.require(:category).permit([:name])
  end



end
