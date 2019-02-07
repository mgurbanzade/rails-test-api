class Location < ApplicationRecord
  has_many :posts
  has_many :users, through: :posts, source: :author

  paginates_per 15

  validates_presence_of :ip

  def self.ip_list
    Location.joins(:users)
            .select(:id, :ip)
            .group(:id, :ip)
            .having('count(users) > 1')
  end
end
