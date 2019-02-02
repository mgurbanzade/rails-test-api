class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :votes, dependent: :destroy

  validates_presence_of :title, :body

  def self.top_posts
    Post.joins(:votes)
        .select('posts.*, AVG(votes.value) AS average_ratings')
        .group('posts.id')
        .order('average_ratings DESC')
  end

  def self.ip_list
    list = Post.includes(:author)
               .where(author_ip: Post.select(:author_ip)
                                     .group(:author_ip)
                                     .having("COUNT(author_ip) > 1"))

    users = User.all.collect(&:login)
    duplicates = list.map { |p| { p.author_ip => users.select { |u| u == p.author.login } } }

    duplicates.flat_map(&:entries)
              .group_by(&:first)
              .map { |ip, arr| Hash[ip, arr.map(&:last).flatten ] }
  end
end
