class Address < ApplicationRecord
  belongs_to :user
  
  validates :city, :state, :country, :pincode, presence: true
end
