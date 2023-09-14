require 'rails_helper'

RSpec.describe 'Subscriptions Index', type: :request do
  describe 'happy paths' do
    before(:each) do
      @tea_1 = create(:tea, price: 10.00)
      @tea_2 = create(:tea, price: 12.00)
      @tea_3 = create(:tea, price: 9.50)
  
      @customer = create(:customer)
      @subscription_1 = create(:subscription, customer: @customer)
      @subscription_2 = create(:subscription, customer: @customer)
      @st_1 = create(:subscription_tea, subscription: @subscription_1, tea: @tea_1)
      @st_2 = create(:subscription_tea, subscription: @subscription_1, tea: @tea_2)
      @st_3 = create(:subscription_tea, subscription: @subscription_1, tea: @tea_3)
  
      @st_4 = create(:subscription_tea, subscription: @subscription_2, tea: @tea_1)
      @st_5 = create(:subscription_tea, subscription: @subscription_2, tea: @tea_1)
      @st_6 = create(:subscription_tea, subscription: @subscription_2, tea: @tea_2)
      @st_7 = create(:subscription_tea, subscription: @subscription_2, tea: @tea_3)
    end

    it 'successfully makes request' do 
      get "/api/v1/customers/#{@customer.id}/subscriptions"

      expect(response).to be_successful
      expect(response.status).to eq(200)
    end

    it 'request returns json' do 
      get "/api/v1/customers/#{@customer.id}/subscriptions"
      
      subscriptions_collection = JSON.parse(response.body, symbolize_names: true)
      expect(subscriptions_collection).to be_a Hash
      
      subscriptions = subscriptions_collection[:data]
      
      expect(subscriptions).to be_an Array
      
      subscriptions.each do |subscription|
        check_hash_structure(subscription, :id, String)
        check_hash_structure(subscription, :type, String)
        check_hash_structure(subscription, :attributes, Hash)
        expect(subscription[:type]).to eq('subscription')
        
        subscription_attributes = subscription[:attributes]
        expect(subscription_attributes).to have_key(:cost)
        expect(subscription_attributes).to have_key(:frequency)
        expect(subscription_attributes).to have_key(:status)
        expect(subscription_attributes).to have_key(:customer_id)
        expect(subscription_attributes).to have_key(:created_at)
        expect(subscription_attributes).to have_key(:updated_at)
        expect(subscription_attributes).to have_key(:teas)
      end
    end
  end

  describe 'edge cases' do 
    it 'returns an array if no subscriptions' do 
      customer = create(:customer)
      
      get "/api/v1/customers/#{customer.id}/subscriptions"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      subscriptions_collection = JSON.parse(response.body, symbolize_names: true)
      expect(subscriptions_collection).to be_a Hash
      
      subscriptions = subscriptions_collection[:data]
      
      expect(subscriptions).to be_an Array     
      expect(subscriptions).to be_empty
    end

    it 'throws error if customer does not exist' do 
      customer_id = create(:customer).id
      bad_id = customer_id + 1 
      expect(Customer.where(id: bad_id)).to be_empty

      get "/api/v1/customers/#{bad_id}/subscriptions"
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
  end
end