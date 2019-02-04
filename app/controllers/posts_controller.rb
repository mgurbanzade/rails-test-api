class PostsController < ApplicationController
  def create
    request_ip = !params[:author_ip].present? ? request.remote_ip : params[:author_ip]
    location = Location.find_by(ip: request_ip)
    location = Location.create(ip: request_ip) unless location.present?

    post = Post.new(post_params)
    user = User.find_by(login: params[:author_login])
    user = User.create(login: params[:author_login]) unless user.present?

    post.author = user
    post.location = location
    post.save

    return render json: PostSerializer.new(post) if post.save
    render json: post.errors.full_messages, status: 422
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
    params.require(:post).permit(:title, :body, :author_ip)
  end
end
