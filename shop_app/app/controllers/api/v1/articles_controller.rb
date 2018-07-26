module Api::V1
  class ArticlesController < ApiController

    def index
      @articles   = Article.all.paginate page: params[:page], per_page: 9
      render json: @articles
    end

    def show
      article = Article.find(params[:id])
      if article.present?
        render json: article
      else
        render json: { message: "Article can't be found!" }
      end
    end
  end
end