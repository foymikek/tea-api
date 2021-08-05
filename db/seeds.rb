# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
20.times do
  Customer.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    address: Faker::Address.full_address
  )
end

20.times do
  Tea.create(
    title: Faker::Tea.variety,
    description: Faker::Coffee.notes,
    temperature: Faker::Number.between(from: 75, to: 100),
    brew_time: Faker::Number.between(from: 1, to: 5)
  )
end

20.times do
  Subscription.create(
    title: Faker::Lorem.sentence(word_count: 3), 
    price: Faker::Commerce.price(range: 10.0..30.0), 
    status: "active",
    tea_id: Tea.all.sample.id,
    customer_id: Customer.all.sample.id,
    frequency: (0..99).to_a.sample
  )
end
