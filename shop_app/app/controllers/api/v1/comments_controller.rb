module Api::V1
  class CommentsController < ApiController

    def create
      article = Article.find_by(id: params[:articles][:article_id])
      @comment = article.comments.create!(comment_params)
      render json: @comment
    end

    def destroy
      article   = Article.find_by(id: params[:articles][:article_id])
      @comments = []
      @comments << article.comments.find_by(id: params[:comments][:id])
      @comments << article.comments.find_by(parent_id: params[:comments][:parent_id])
      @comments.each do |comment|
        if comment != nil
          comment.destroy
        end  
      end
      render json: {status: 'Delete comment success!'}, status: :ok  
    end

    private

      def comment_params
        params.require(:comments).permit(:content, :parent_id)
        .merge(user_id: payload[0]['user_id'])
      end
  end
end