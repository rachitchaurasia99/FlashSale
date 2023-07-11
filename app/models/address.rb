class Address < ApplicationRecord
  belongs_to :user
  has_many :orders
  
  validates :city, :state, :country, :pincode, presence: true

  validates :city, uniqueness: { scope: [:state, :country, :pincode], message: ', State, Country and Pincode combination already taken' }, on: :create

  # validate :address_validator, on: :create

  # before_validation :address_validator, on: :create

  def address_validator
    if Address.find_by(city: city, state: state, country: country, pincode: pincode)
      errors.add(:base, 'Address already exists')
    end
  end
end
