FactoryBot.define do
  factory :payment do
    association :order
  end
end
