class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :location
  has_many :votes, dependent: :destroy

  paginates_per 15

  validates_presence_of :title, :body

  def self.top_posts
    Post.where.not(average_rating: nil)
              .order('average_rating DESC')
  end

  def update_average
    new_average = self.votes.sum(:value) / self.votes.size.to_f
    self.update_column(:average_rating, new_average.round(1))
  end
end
