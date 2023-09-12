frequencies = ['daily', 'weekly', 'fortnightly', 'monthly']

FactoryBot.define do
  factory :subscription do
    frequency { frequencies.sample }
    status { [0, 1].sample }
    title { Faker::Music.album }
    customer
  end
end
