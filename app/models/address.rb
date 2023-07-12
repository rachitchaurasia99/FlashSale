class Address < ApplicationRecord
  belongs_to :user
  has_many :orders
  
  validates :name, :email, :city, :state, :country, :pincode, presence: true

  validates :city, uniqueness: { scope: [:state, :country, :pincode], message: ', State, Country and Pincode combination already taken' }

  # validate :address_validator

  # before_validation :address_validator

  def address_validator
    if Address.find_by(city: city, state: state, country: country, pincode: pincode) != self
      errors.add(:base, 'Address already exists')
    end
  end
end
