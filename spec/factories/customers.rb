FactoryBot.define do
  factory :customer do
    name { Faker::Music::Hiphop.artist }
    email { Faker::Internet.email }
    address { Faker::Address.full_address }
  end
end
