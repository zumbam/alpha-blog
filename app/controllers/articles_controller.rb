class ArticlesController < ApplicationController

  before_action :set_article, only: [:edit, :update, :show, :destroy]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end


  def new
    @article = Article.new
  end

  def edit
  end

  def show
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    successfully_saved = @article.save
    if successfully_saved
      flash['success'] = "the article has been successfully saved"
      redirect_to article_path(@article)
    else
      render 'new'
    end

  end

  def update
    @article = Article.find(params[:id])
    successfully_updated = @article.update(article_params)
    if successfully_updated
      flash['success'] = "article has been successfully updated"
      redirect_to article_path(@article)
    else
      render 'edit'
    end
  end

  def destroy

    successfully_deleted = @article.delete
    if successfully_deleted
      flash['success'] = "the article was successfully deleted"
    end
    redirect_to articles_path
  end

private
  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description)
  end

  def require_same_user
    unless (logged_in? && (current_user == @article.user || current_user.admin))
      flash[:danger] = "you can only edit delete your own article"
      redirect_to root_path
    end
  end
end
