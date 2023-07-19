FactoryBot.define do
  factory :refund do
    association :order
    currency { 'inr' }
    status { 'successful' }
 end
end
