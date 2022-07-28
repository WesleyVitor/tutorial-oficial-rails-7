class ArticlesController < ApplicationController
  http_basic_authenticate_with name:"dhh", password:"secret", except: [:index, :show]


  def index
    #Pega todos os artigos
    @articles = Article.all 
  end

  def show
    #Procura uma artigo com o id passado na rota
    @article = Article.find(params[:id]) 
  end

  def new
    # Cria um objeto de Article vazio para criar um formulário na view new.html.erb
    @article = Article.new 
  end

  def create
    #Cria um objeto de Article preenchido com os valores retornados do método article_params
    @article = Article.new(article_params)

    #If as validações do modelo Article estiver válidos salva no banco de dados
    if @article.save
      redirect_to @article #O rails encontra um nome de url para um artigo específico
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Cria um objeto de Article vazio para criar um formulário na view edit.html.erb
    @article = Article.find(params[:id])
  end

  def update
    #Procura um Article via o id passado na url
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    #Procura um Article via o id passado na url
    @article = Article.find(params[:id])
    if @article.comments.empty?
      @article.destroy
      redirect_to root_path, status: :see_other
    else
      redirect_to @article
    end

  end
  private
    def article_params
      params.require(:article).permit(:title, :body, :status)
    end
end
