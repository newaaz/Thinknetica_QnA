FactoryBot.define do
  factory :answer do
    author { association :user }
    question { association :question }
    body { "Correct answer - you need update gem" }    

    trait :invalid do
      body { nil }
    end
  end
end
