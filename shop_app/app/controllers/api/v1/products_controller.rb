module Api::V1
  class ProductsController < ApiController
    def index
      render json: Product.all
    end

    def show
      product = Product.find(params[:id])
      if product.present?
        render json: product
      else
        render json: { message: "Product can't be found!" }
      end
    end
  end
end