FactoryBot.define do
  factory :user_party do
    viewing_party { association :viewing_party }
    user { association :user }
    host { true }

    trait :guest do
      user { association :user }
      host { false }
    end
  end
end