FactoryBot.define do
  factory :line_item do
    association :deal
    association :order
    quantity { Faker::Number.between(from: 12, to: 100) }
    price_in_cents { deal.price_in_cents }
    discount_price_in_cents { deal.discount_price_in_cents }
    
    after(:create) do |line_item|
      line_item.tax_in_cents { deal.tax_in_cents * quantity }
      line_item.total_in_cents { deal.price_in_cents * quantity }
      line_item.total_discount_price_in_cents { deal.discount_price_in_cents * quantity }
      line_item.net_in_cents { total_discount_price_in_cents + tax_in_cents }
    end
  end
end
