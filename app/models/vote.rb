class Vote < ApplicationRecord
  belongs_to :post

  validates :value, presence: true, inclusion: 1..5
end
