FactoryBot.define do
  factory :deal do
    title { Faker::Device.model_name }
    description { Faker::Lorem.unique.sentence }
    price_in_cents { Faker::Commerce.price(range: 1..1000) }
    discount_price_in_cents { Faker::Commerce.price(range: 1..price_in_cents) }
    quantity { Faker::Number.between(from: 12, to: 100) }
    tax_percentage { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    publish_at { Faker::Time.between(from: DateTime.now-1, to: DateTime.now) }
  end
end
