class User < ApplicationRecord
  has_many :posts, foreign_key: 'author_id', dependent: :destroy

  validates_presence_of :login
end
