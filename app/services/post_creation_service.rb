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
    return location.errors.full_messages unless location.valid?

    user = User.find_by(login: params[:author_login])
    user = User.new(login: params[:author_login]) unless user.present?
    return user.errors.full_messages unless user.valid?

    post = Post.new(post_params)
    post.author = user
    post.location = location
    return post.errors.full_messages unless post.valid?

    location.save
    user.save
    post.save

    PostSerializer.new(post)
  end
end
