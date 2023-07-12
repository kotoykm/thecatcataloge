class OpinionsController < ApplicationController
    before_action only: [:edit, :update, :destroy] do
        authorize_request(["admin"])
      end
      
    def index
        @client = Client.find(params[:client_id])
        @opinions = @client.opinions
    end
    def create
        @article = Article.find(params[:opinion][:article_id])
        
        @opinion = Opinion.new(opinion_params)
        @opinion.client = current_client

        if client_signed_in?
            @opinion.client.id = current_client.id
        else
            @opinion.client_id = 2
        end

        respond_to do |format|
            if @opinion.save
                format.html { redirect_to article_path(@article.id), notice: 'Comment was successfully created.' }
            else
                format.html { redirect_to article_path(@article.id), notice: 'Comment was not created.' }
            end
        end
    end

    private

    def opinion_params
        params.require(:opinion).permit(:content, :article_id)
    end
end
