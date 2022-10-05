FactoryBot.define do
  factory :comment do
    user_id { create(:user).id }

    trait :for_question do
      sequence(:body) { |n| "Comment for question № #{n}" }
      association :commentable, factory: :question      
    end

    trait :for_answer do
      sequence(:body) { |n| "Comment for answer № #{n}" }
      association :commentable, factory: :answer
    end
  end
end
