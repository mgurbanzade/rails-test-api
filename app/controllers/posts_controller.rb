class PostsController < ApplicationController
  def create
    @post = Post.new(post_params)
    @post.author_ip = request.remote_ip
    @user = User.find_by(login: params[:author_login])

    unless @user.present?
      @user = User.create(login: params[:author_login])
    end

    @post.author = @user
    @post.save

    return render json: PostSerializer.new(@post) if @post.save
    render json: @post.errors.full_messages, status: 422
  end

  def rate
    @post = Post.find(params[:id])
    @vote = @post.votes.create(value: params[:vote])

    if @vote.errors.present?
      render json: @vote.errors.full_messages, status: 422
    else
      render json: {rating: @post.average_rating}
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :author_ip)
  end
end
