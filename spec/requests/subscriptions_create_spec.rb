require 'rails_helper'

RSpec.describe 'Subscription Creation', type: :request do
  before(:each) do
    @tea_1 = create(:tea)
    @tea_2 = create(:tea)
    @tea_3 = create(:tea)

    @customer = create(:customer)

    @headers = { 
      "CONTENT_TYPE" => "application/json"
    }
    @subscription_info = {
        teas: [@tea_1.id, @tea_2.id, @tea_3.id],
        frequency: 'fortnightly',
        title: 'That Good Good'
    }
  end

  describe 'happy path' do
    it 'creates new subscription' do 
      subscription_count = Subscription.count

      post "/api/v1/customers/#{@customer.id}/subscriptions", headers: @headers, params: @subscription_info, as: :json
      expect(response).to be_successful
      expect(response.status).to eq(201)
      expect(Subscription.count).to eq(subscription_count + 1)
      
      subscription = JSON.parse(response.body, symbolize_names: true)[:data]

      check_hash_structure(subscription, :id, String)
      check_hash_structure(subscription, :type, String)
      check_hash_structure(subscription, :attributes, Hash)
      expect(subscription[:type]).to eq('subscription')
      
      subscription_attributes = subscription[:attributes]
      expect(subscription_attributes).to have_key(:cost)
      expect(subscription_attributes).to have_key(:frequency)
      expect(subscription_attributes[:frequency]).to eq('fortnightly')
      expect(subscription_attributes).to have_key(:status)
      expect(subscription_attributes[:status]).to eq('active')
      expect(subscription_attributes).to have_key(:customer_id)
      expect(subscription_attributes[:customer_id]).to eq(@customer.id)
      expect(subscription_attributes).to have_key(:created_at)
      expect(subscription_attributes).to have_key(:updated_at)
      expect(subscription_attributes).to have_key(:teas)
    end
    
    it 'subscription has teas' do 
      post "/api/v1/customers/#{@customer.id}/subscriptions", headers: @headers, params: @subscription_info, as: :json

      subscription = Subscription.first

      expect(subscription.teas).to eq([@tea_1, @tea_2, @tea_3])
    end
  end

  describe 'sad paths' do 
    it 'throws error if frequency not specified' do 
      create(:subscription)
      subscription_count = Subscription.count

      incomplete_subscription_info = {
        teas: [@tea_1.id, @tea_3.id], #change this 
        title: 'That Good Good'
      }
      
      post "/api/v1/customers/#{@customer.id}/subscriptions", headers: @headers, 
      params: incomplete_subscription_info, as: :json
      
      expect(response).to_not be_successful
      expect(response.status).to eq(422)
      expect(subscription_count).to eq(subscription_count)
      error = JSON.parse(response.body, symbolize_names: true)
      
      check_hash_structure(error, :error, Hash)
      check_hash_structure(error[:error], :status, Integer)
      check_hash_structure(error[:error], :message, String)
      
      error_attributes = error[:error]
      expect(error_attributes[:status]).to eq(422)
      expect(error_attributes[:message]).to eq("Validation failed: Frequency can't be blank")
    end
    
    it 'throws error if no title' do 
      incomplete_subscription_info = {
        frequency: 'monthly', 
        teas: [@tea_1.id, @tea_2.id]
      }
      
      subscription_count = Subscription.count
      
      post "/api/v1/customers/#{@customer.id}/subscriptions", 
      headers: @headers, params: incomplete_subscription_info, as: :json
      
      expect(response).to_not be_successful
      expect(response.status).to eq(422)
      expect(subscription_count).to eq(subscription_count)
      
      error = JSON.parse(response.body, symbolize_names: true)
      
      check_hash_structure(error, :error, Hash)
      check_hash_structure(error[:error], :status, Integer)
      check_hash_structure(error[:error], :message, String)
      
      error_attributes = error[:error]
      expect(error_attributes[:status]).to eq(422)
      expect(error_attributes[:message]).to eq("Validation failed: Title can't be blank")
    end

    it 'throws error if customer does not exist' do 
      bad_id = @customer.id + 30
      expect(Customer.where(id: bad_id)).to be_empty
      
      post "/api/v1/customers/#{bad_id}/subscriptions", 
      headers: @headers, params: @params, as: :json
      
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      error = JSON.parse(response.body, symbolize_names: true)
      
      check_hash_structure(error, :error, Hash)
      check_hash_structure(error[:error], :status, Integer)
      check_hash_structure(error[:error], :message, String)
      
      error_attributes = error[:error]
      expect(error_attributes[:status]).to eq(404)
      expect(error_attributes[:message]).to eq("Couldn't find Customer with 'id'=#{bad_id}")
    end
    
    it 'throws error if tea does not exist' do 
      bad_tea_id = @tea_3.id + 1
      expect(Tea.where(id: bad_tea_id)).to be_empty
      
      bad_tea_subscription_info = {
        teas: [@tea_1.id, @tea_2.id, bad_tea_id],
        frequency: 'fortnightly',
        title: 'That Good Good'
      }

      post "/api/v1/customers/#{@customer.id}/subscriptions", 
      headers: @headers, params: bad_tea_subscription_info, as: :json
      
      expect(response).to_not be_successful
      expect(response.status).to eq(422)
      error = JSON.parse(response.body, symbolize_names: true)
      check_hash_structure(error, :error, Hash)
      check_hash_structure(error[:error], :status, Integer)
      check_hash_structure(error[:error], :message, String)
      
      error_attributes = error[:error]
      expect(error_attributes[:status]).to eq(422)
      expect(error_attributes[:message]).to eq("Validation failed: Tea must exist")
    end
  end
end