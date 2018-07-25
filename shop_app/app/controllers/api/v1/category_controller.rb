module Api::V1
  class CategoryController < ApiController
    def index
      render json: Category.all
    end

    def show
      category = Category.find(params[:id])
      if category.present?
        render json: category
      else
        render json: { message: "Category can't be found!" }
      end
    end
  end
end