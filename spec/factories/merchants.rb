FactoryBot.define do
  factory :merchant do
    name { "#{Faker::Hobby.activity.titleize} Shop" }
  end
end
