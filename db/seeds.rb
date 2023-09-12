# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Customer.destroy_all
Subscription.destroy_all
Tea.destroy_all 
frequencies = ['daily', 'weekly', 'fortnightly', 'monthly']

3.times{
  Tea.create!(
    name: Faker::Tea.variety,
    price: Faker::Number.decimal(l_digits: 2, ),
    description: Faker::Movies::Hobbit.quote
  )
}

Customer.create!(
  name: Faker::Music::Hiphop.artist, 
  email: Faker::Internet.email,
  address: Faker::Address.full_address
)

2.times {
  Subscription.create!(
    frequency: frequencies.sample,
    status: [0, 1].sample,
    title: Faker::Music.album,
    customer: Customer.first
  )
}

teas = Tea.all

subscriptions = Subscription.all

subscriptions.each do |subscription|
  2.times {
    SubscriptionTea.create!(subscription_id: subscription.id, tea_id: teas.sample.id)
  }
end