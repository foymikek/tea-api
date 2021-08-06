require 'rails_helper'

RSpec.describe 'See Customer Subscriptions' do
  describe 'happy paths' do
    it "can show all subscriptions for a customer" do
      customer = Customer.create(
          first_name: Faker::Name.first_name,
          last_name:  Faker::Name.last_name,
          email:      Faker::Internet.email,
          address:    Faker::Address.full_address
       )

      tea      = Tea.create(
          title:       Faker::Tea.variety,
          description: Faker::Coffee.notes,
          temperature: Faker::Number.between(from: 75, to: 100),
          brew_time:   Faker::Number.between(from: 1, to: 5)
        )

      5.times do
        customer.subscriptions.create(
          title:  Faker::Lorem.sentence(word_count: 3),
          price:  Faker::Commerce.price(range: 10.0..30.0),
          status: "active",
          tea_id: tea.id,
          frequency: (0..99).to_a.sample
          )
      end

      get "/api/v1/customers/#{customer.id}/subscriptions"
      subs = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(subs[:data]).to be_an(Array)
      expect(subs[:data].first[:attributes][:customer_id]).to eq(customer.id)
      expect(subs[:data].first[:type]).to eq("subscription")
      expect(subs[:data].first[:attributes]).to have_key(:tea_id)
      expect(subs[:data].first[:attributes]).to have_key(:title)
      expect(subs[:data].first[:attributes]).to have_key(:price)
      expect(subs[:data].first[:attributes]).to have_key(:status)
      expect(subs[:data].first[:attributes]).to have_key(:frequency)
    end
  end

  describe 'sad paths/edge cases' do
    it 'shows error if customer does not exist' do
      customer = Customer.create(
          first_name: Faker::Name.first_name,
          last_name:  Faker::Name.last_name,
          email:      Faker::Internet.email,
          address:    Faker::Address.full_address
        )

      customer.id = 1

      get "/api/v1/customers/2/subscriptions"
      subs = JSON.parse(response.body, symbolize_names: true)
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      expect(subs[:errors]).to eq("Cannot find customer")
    end

    it 'shows message if customer has no subscriptions' do
      customer = Customer.create(
          first_name: Faker::Name.first_name,
          last_name:  Faker::Name.last_name,
          email:      Faker::Internet.email,
          address:    Faker::Address.full_address
        )

      get "/api/v1/customers/#{customer.id}/subscriptions"
      subs = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(subs[:message]).to eq("No subscriptions found")
    end
  end
end