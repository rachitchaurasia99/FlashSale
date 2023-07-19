FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "Test user #{n}" }
    sequence(:email) { |n| "user#{n}@gmail.com" }
    password { "abcdef" }
    password_confirmation { "abcdef" }
    confirmed_at { Time.current }
    
    trait :admin do
      first_name { 'admin' }
      email { 'admin@mail.com' }
      password { 'Admin123' }
      password_confirmation { 'Admin123' }
      role { :admin }
    end
  end
end
