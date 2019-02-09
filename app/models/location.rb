class Location < ApplicationRecord
  has_many :posts
  has_many :users, through: :posts, source: :author

  validates_presence_of :ip

  scope :with_offset, -> (offset, limit = 15) {
    select(:id, :ip).group(:id, :ip).offset(offset).limit(limit)
  }
end
