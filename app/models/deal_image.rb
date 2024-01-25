class DealImage < ApplicationRecord
  belongs_to :deal
  has_one_attached :image
end
