frequencies = ['daily', 'weekly', 'fortnightly', 'monthly']

FactoryBot.define do
  factory :subscription do
    cost { Faker::Number.decimal(l_digits: 2, r_digits: 1) }
    frequency { frequencies.sample }
    status { [0, 1].sample }
    title { Faker::Music.album }
    customer
  end
end
