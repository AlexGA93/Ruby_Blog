class ArticlesController < ApplicationController
  http_basic_authenticate_with name: "dhh", password: "secret", except: [:index, :show]
  
  # @GET /articles
  def index
    @articles = Article.all
  end

   # @GET /articles/:id
  def show
    @article = Article.find(params[:id])
  end

  # @GET /articles/new
  def new
    @article = Article.new
  end

  # @GET /articles
  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to @article
    else
      render :new
    end
  end

   # @GET /friends/:id/edit
  def edit
    @article = Article.find(params[:id])
  end

  # @PATCH/PUT /articles/:id
  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit
    end
  end

  # @DELETE /articles/:id
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path
  end


  #Only allow a list of trusted parameters
  def article_params
    params.require(:article).permit(:title, :body, :created_at, :updated_at)
  end

  private
    def article_params
      params.require(:article).permit(:title, :body, :status)
    end


end


