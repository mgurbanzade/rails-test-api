class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :votes, dependent: :destroy
end
