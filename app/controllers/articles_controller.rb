class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]
  before_action only: [:new, :create, :edit, :update, :destroy] do #Restriccion 1
    authorize_request(["author", "admin"])
  end

  # GET /articles or /articles.json
  def index
    @articles = Article.all
  end

  # GET /articles/1 or /articles/1.json
  def show
    @opinion = Opinion.new
  
    @article = Article.find(params[:id])
    @opinions = @article.opinions
    @reaction = Reaction.new
  
    if client_signed_in?
      @gatebutton = ""
      @active_kinds = Article::Kinds.select { |kind| @article.reactions.exists?(client: current_client, kind: kind) }
    else
      @gatebutton = "disabled"
      @active_kinds = []
    end
  end

  # GET /articles/new
  def new
    @article = Article.new
    
  end

  # GET /articles/1/edit
  def edit
    
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)

    if client_signed_in?
      @article.client = current_client
    else
      @article.client_id = 2
    end

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :picture, :description, :client_id)
    end
end
