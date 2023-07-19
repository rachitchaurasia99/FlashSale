FactoryBot.define do
  factory :line_item do
    association :deal
    association :order
    quantity { 1 }
    price_in_cents { deal.price_in_cents }
    discount_price_in_cents { deal.discount_price_in_cents }
    tax_in_cents { deal.tax_in_cents * quantity }
    total_in_cents { deal.price_in_cents * quantity }
    total_discount_price_in_cents { deal.discount_price_in_cents * quantity }
    net_in_cents { total_discount_price_in_cents + tax_in_cents }
  end
end
