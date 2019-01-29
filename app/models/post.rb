class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :votes, dependent: :destroy

  validates_presence_of :title, :body

  def average_rating
    votes = self.reload.votes.map { |v| v.value }
    (votes.sum / votes.size.to_f).round(1)
  end
end
