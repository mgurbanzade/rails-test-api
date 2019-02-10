class PostCreationService
  attr_reader :post_params, :params, :ip

  def initialize(post_params, params, ip)
    @post_params = post_params
    @params = params
    @ip = ip
  end

  def call
    location = Location.find_by(ip: ip)
    location = Location.new(ip: ip) unless location.present?
    return {body: location.errors.full_messages, status: 422} unless location.valid?

    user = User.find_by(login: params[:author_login])
    user = User.new(login: params[:author_login]) unless user.present?
    return {body: user.errors.full_messages, status: 422} unless user.valid?

    post = Post.new(post_params)
    post.author = user
    post.location = location
    return {body: post.errors.full_messages, status: 422} unless post.valid?

    location.save
    user.save
    post.save

    {body: PostSerializer.new(post), status: 200}
  end
end
