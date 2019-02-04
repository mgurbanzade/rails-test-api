class Vote < ApplicationRecord
  belongs_to :post

  validates :value, presence: true, inclusion: 1..5

  after_create :update_post_average

  def update_post_average
    self.post.update_average
  end
end
