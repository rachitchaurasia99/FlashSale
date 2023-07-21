FactoryBot.define do
  factory :admin_user, class: :user do
    first_name { Faker::Name.name  }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    password_confirmation { password }
    confirmed_at { Faker::Time.between(from: DateTime.now-1, to: DateTime.now) }
    role { :admin }
  end
end
