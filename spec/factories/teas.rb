FactoryBot.define do
  factory :tea do
    name { Faker::Tea.variety }
    price { Faker::Number.decimal(l_digits: 2, ) }
    description { Faker::Movies::Hobbit.quote }
  end
end
