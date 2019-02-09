class PostRatingService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    post = Post.find(params[:id])
    vote = post.votes.new(value: params[:vote])
    return {body: vote.errors.full_messages, status: 422} unless vote.valid?

    vote.save
    {body: post.average_rating, status: 200}
  end
end
