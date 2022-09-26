FactoryBot.define do
  sequence :email do |n|
    "user_#{n}@test.com"
  end

  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }
    #confirmed_at { Time.now }
    #before(:create) { |user| user.skip_confirmation! }
    before(:create) { |user| user.confirm }
  end
end
