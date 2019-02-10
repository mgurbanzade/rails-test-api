class PostsController < ApplicationController
  def create
    response = PostCreationService.new(post_params, params, request.remote_ip).call
    render json: response[:body], status: response[:status]
  end

  def rate
    response = PostRatingService.new(params).call
    render json: response[:body], status: response[:status]
  end

  def most_rated
    paginate json: Post.top_posts
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
