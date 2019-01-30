class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :votes, dependent: :destroy

  validates_presence_of :title, :body

  def self.top_posts
    Post
      .where('id IN (SELECT DISTINCT(post_id) FROM votes)')
      .sort_by(&:average_rating)
  end

  def self.ip_list
    list = Post.select(:author_ip).group(:author_ip).having("COUNT(author_ip) > 1")
            .map { |p| p.author_ip.to_s }.to_a

    list.map { |ip| { ip => Post.where(author_ip: ip).collect(&:author).collect(&:login)} }
  end

  def average_rating
    votes = self.reload.votes.map { |v| v.value }
    (votes.sum / votes.size.to_f).round(1)
  end
end
