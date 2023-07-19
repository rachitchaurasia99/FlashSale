FactoryBot.define do
  factory :deal do
    sequence(:title) { |n| "Title #{n}" }
    description { 'abc def ghi' }
    price_in_cents { 1000 }
    discount_price_in_cents { 900 }
    quantity { 12 }
    tax_percentage { 10.0 }
    publish_at { Time.current }
  end
end
