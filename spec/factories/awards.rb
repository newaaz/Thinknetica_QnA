FactoryBot.define do
  factory :award do
    title { "Award title" }
    question
    user { nil }
    image { Rack::Test::UploadedFile.new('app/assets/images/icons/award.png') }
  end
end
