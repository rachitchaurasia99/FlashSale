FactoryBot.define do
  factory :address do
    association :user
    name  { 'abc '}
    email  { 'abc@gmail.com '}
    city  { 'abcd '}
    state  { 'abcde '}
    country  { 'abcdef '}
    sequence(:pincode) { |n| rand(100000..999999) }
  end
end
