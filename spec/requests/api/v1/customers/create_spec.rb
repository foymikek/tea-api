require 'rails_helper'

RSpec.describe 'Subscribe a Customer' do
  describe 'happy paths' do
    it "can create a new subscription for a customer" do
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

      headers = {
        'Content-Type': "application/json",
        'Accept': "application/json"
      }

      body = {
        "customer_id": customer.id,
        "tea_id": tea.id,
        "title": "#{customer.first_name}'s Subscription for #{tea.title}",
        "price": 12.05,
        "status": "active",
        "frequency": 1
      }

      post "/api/v1/customers/#{customer.id}/subscriptions", headers: headers, params: body.to_json
      sub = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(201)

      expect(sub[:data]).to be_a Hash
      expect(sub[:data][:attributes]).to have_key(:customer_id)
      expect(sub[:data][:attributes]).to have_key(:tea_id)
      expect(sub[:data][:attributes]).to have_key(:title)
      expect(sub[:data][:attributes]).to have_key(:price)
      expect(sub[:data][:attributes]).to have_key(:status)
      expect(sub[:data][:attributes]).to have_key(:frequency)

      expect(sub[:data][:attributes][:customer_id]).to be_an(Integer)
      expect(sub[:data][:attributes][:tea_id]).to be_an(Integer)
      expect(sub[:data][:attributes][:title]).to be_a(String)
      expect(sub[:data][:attributes][:price]).to be_a(Float)
      expect(sub[:data][:attributes][:status]).to eq("active")
      expect(sub[:data][:attributes][:frequency]).to eq(1)
    end
  end

  describe 'sad paths/edge cases' do
    it 'can show error if field is missing' do
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

      headers = {
        'Content-Type': "application/json",
        'Accept': "application/json"
      }

      body = {
        "customer_id": customer.id,
        "tea_id": tea.id,
        "title": "#{customer.first_name}'s Subscription for #{tea.title}",
        "price": 12.05,
        "status": 0
      }

      post "/api/v1/customers/#{customer.id}/subscriptions", headers: headers, params: body.to_json
      sub = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      expect(sub[:errors]).to eq("Frequency can't be blank")
    end

    it 'alerts customer if they are already subscribed to a tea' do
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

      customer.subscriptions.create(
          title:     Faker::Lorem.sentence(word_count: 3),
          price:     Faker::Commerce.price(range: 10.0..30.0),
          status:    "active",
          tea_id:    tea.id,
          frequency: (0..99).to_a.sample
        )

      headers = {
        'Content-Type': "application/json",
        'Accept': "application/json"
      }

      body = {
        "customer_id": customer.id,
        "tea_id": tea.id,
        "title": "#{customer.first_name}'s Subscription for #{tea.title}",
        "price": 12.05,
        "status": 0,
        "frequency": 0
      }

      post "/api/v1/customers/#{customer.id}/subscriptions", headers: headers, params: body.to_json
      sub = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      expect(sub[:errors]).to eq("You're already subscribed to this tea")
    end

    it 'shows an error if tea does not exist' do
      customer = Customer.create(
          first_name: Faker::Name.first_name,
          last_name:  Faker::Name.last_name,
          email:      Faker::Internet.email,
          address:    Faker::Address.full_address
        )

      headers = {
        'Content-Type': "application/json",
        'Accept': "application/json"
      }

      body = {
        "customer_id": customer.id,
        "tea_id": 1,
        "title": "#{customer.first_name}'s Subscription for a tea that doens't exist",
        "price": 12.05,
        "status": 0,
        "frequency": 0
      }

      post "/api/v1/customers/#{customer.id}/subscriptions", headers: headers, params: body.to_json
      sub = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      # expect(sub[:errors]).to eq("Cannot find tea")
    end
  end
end