FactoryGirl.define do

  factory :post do
    title  Faker::Lorem.words(5).join(" ")
    body Faker::Lorem.paragraph
  end
end
