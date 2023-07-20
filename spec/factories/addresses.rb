require 'faker'

FactoryBot.define do
  factory :address do
    association :user
    name  { Faker::Name.name }
    email  { Faker::Internet.email }
    city  { Faker::Address.city }
    state  { Faker::Address.state }
    country  { Faker::Address.country }
    pincode { Faker::Address.zip }
  end
end
