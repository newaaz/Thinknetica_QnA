FactoryBot.define do
  sequence :title do |n|
    "Title of question #{n}"
  end

  factory :question do
    author { association :user }
    title
    body { "MyText" }

    trait :invalid do
      title { nil }
    end
  end
end
