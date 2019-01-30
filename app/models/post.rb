class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :votes, dependent: :destroy

  validates_presence_of :title, :body

  def self.top_posts
    Post
      .where('id IN (SELECT DISTINCT(post_id) FROM votes)')
      .sort_by(&:average_rating)
  end

  def average_rating
    votes = self.reload.votes.map { |v| v.value }
    (votes.sum / votes.size.to_f).round(1)
  end
end
