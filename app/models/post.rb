class Post < ApplicationRecord
  belongs_to :author, class_name: 'User', touch: true
  belongs_to :location, touch: true
  has_many :votes, dependent: :destroy

  paginates_per 15

  validates_presence_of :title, :body, :location_id

  after_touch :save
  after_save :create_json_cache

  scope :top_posts, -> {
    where.not(average_rating: nil).order('average_rating DESC')
  }

  def update_average
    new_average = self.votes.sum(:value) / self.votes.size.to_f
    self.update_column(:average_rating, new_average.round(1))
  end

  private

  def create_json_cache
    CreateLocationsJsonCacheJob.perform_later
  end
end
