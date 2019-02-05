class PostsController < ApplicationController
  def create
    render json: PostCreationService.new(post_params, params, request.remote_ip).call
  end

  def rate
    post = Post.find(params[:id])
    vote = post.votes.create(value: params[:vote])

    return render json: {rating: post.average_rating} unless vote.errors.present?
    render json: vote.errors.full_messages, status: 422
  end

  def most_rated
    paginate json: Post.top_posts
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
