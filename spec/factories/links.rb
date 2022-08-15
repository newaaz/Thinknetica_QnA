FactoryBot.define do
  factory :link do

    trait :for_question do
      name { "Link for question" }
      url { "https://gist.github.com/newaaz/78edbf7ec647d87cacd1bffa2a51b3ad" }
      association :linkable, factory: :question
    end

    trait :for_answer do
      name { "Link for answer" }
      url { "https://gist.github.com/newaaz/78edbf7ec647d87cacd1bffa2a51b3ad" }
      association :linkable, factory: :answer
    end

  end
end
