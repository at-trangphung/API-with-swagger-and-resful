module Api::V1
  class CommentsProductController < ApiController

    def create
      product = Product.find_by(id: params[:products][:product_id])
      @comment = product.comment_products.create!(comment_params)
      render json: @comment
    end

    def destroy
      product = Product.find_by(id: params[:products][:product_id])
      @comments = []
      @comments << product.comment_products.find_by(id: params.require(:comments_product)[:id])
      @comments << product.comment_products.find_by(parent_id: params.require(:comments_product)[:parent_id])
      @comments.each do |comment|
        if comment != nil
          comment.destroy
        end  
      end
      render json: {status: 'Delete comment success!'}, status: :ok  
    end

    private

      def comment_params
        params.require(:comments_product).permit(:content, :parent_id)
        .merge(user_id: payload[0]['user_id'])
      end
  end
end