FactoryBot.define do
  factory :order do
    association :user
    association :address
    status { :in_progress }

    trait :is_placed do
      status { :placed }
    end

    trait :be_delivered do
      status { :delivered }
    end
  end
end
