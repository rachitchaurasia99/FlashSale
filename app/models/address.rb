class Address < ApplicationRecord
  belongs_to :user
  has_many :orders
  
  validates :name, :email, :city, :state, :country, :pincode, presence: true

  validates :city, uniqueness: { scope: [:state, :country, :pincode], message: ', State, Country and Pincode combination already taken' }, if: :attributes_changed?

  # validate :address_validator, if: :attributes_changed?

  # before_validation :address_validator, if: :attributes_changed?

  def attributes_changed?
    city_changed? || state_changed? || country_changed? || pincode_changed?
  end

  def address_validator
    if Address.find_by(city: city, state: state, country: country, pincode: pincode)
      errors.add(:base, 'Address already exists')
    end
  end
end
