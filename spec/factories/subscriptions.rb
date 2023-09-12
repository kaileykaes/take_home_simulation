FactoryBot.define do
  factory :subscription do
    cost { 1.5 }
    frequency { "MyString" }
    status { "MyString" }
    title { "MyString" }
    customers { nil }
    teas { nil }
  end
end
