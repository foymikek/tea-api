require 'rails_helper'

RSpec.describe 'Update Subscriptions' do
  describe 'happy paths' do
    it "can cancel a customers subscription" do
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
            
      sub_1    = customer.subscriptions.create(
          title:     Faker::Lorem.sentence(word_count: 3),
          price:     Faker::Commerce.price(range: 10.0..30.0),
          status:    "active",
          tea_id:    tea.id,
          frequency: (0..99).to_a.sample
        )

      sub_2    = customer.subscriptions.create(
          title:     Faker::Lorem.sentence(word_count: 3),
          price:     Faker::Commerce.price(range: 10.0..30.0),
          status:    "active",
          tea_id:    tea.id,
          frequency: (0..99).to_a.sample
        )

      sub_3    = customer.subscriptions.create(
          title:     Faker::Lorem.sentence(word_count: 3),
          price:     Faker::Commerce.price(range: 10.0..30.0),
          status:    "active",
          tea_id:    tea.id,
          frequency: (0..99).to_a.sample
        )

      expect(sub_1.status).to eq("active")
      expect(sub_2.status).to eq("active")
      expect(sub_3.status).to eq("active")

      patch "/api/v1/customers/#{customer.id}/subscriptions/#{sub_2.id}", params: {status: "inactive"}
      sub = JSON.parse(response.body, symbolize_names: true)
      
      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(sub[:data][:id].to_i).to eq(sub_2.id)
      expect(sub[:data][:attributes][:status]).to eq("inactive")
    end
  end

  describe 'sad paths/edge cases' do
    it "shows error if invalid status given" do
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
            
      sub_1    = customer.subscriptions.create(
          title:     Faker::Lorem.sentence(word_count: 3),
          price:     Faker::Commerce.price(range: 10.0..30.0),
          status:    "active",
          tea_id:    tea.id,
          frequency: (0..99).to_a.sample
        )

      sub_2    = customer.subscriptions.create(
          title:     Faker::Lorem.sentence(word_count: 3),
          price:     Faker::Commerce.price(range: 10.0..30.0),
          status:    "active",
          tea_id:    tea.id,
          frequency: (0..99).to_a.sample
        )

      sub_3    = customer.subscriptions.create(
          title:     Faker::Lorem.sentence(word_count: 3),
          price:     Faker::Commerce.price(range: 10.0..30.0),
          status:    "active",
          tea_id:    tea.id,
          frequency: (0..99).to_a.sample
        )

      patch "/api/v1/customers/#{customer.id}/subscriptions/#{sub_2.id}", params: {status: "dislike"}
      sub = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(sub[:errors]).to eq("Invalid status")
    end
  end
end