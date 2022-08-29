FactoryBot.define do
  factory :item do
    name { "#{[Faker::Adjective.positive,Faker::Adjective.negative].sample.titleize} #{Faker::Food.dish}" }
    description {
      [Faker::Quotes::Shakespeare.hamlet]
    }
    unit_price { rand(100..100_000)}
    merchant_id {}
  end
end