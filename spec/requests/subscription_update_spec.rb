require 'rails_helper'

RSpec.describe 'Subscription Cancellation', type: :request do
  before(:each) do 
    @customer = create(:customer)
    @subscription_1 = create(:subscription, customer: @customer, status: 'active')
    @subscription_2 = create(:subscription, customer: @customer, status: 'inactive')
  end

  describe 'happy path' do
    it 'cancels existing subscription' do 
      params = {
        status: 'inactive'
      }
  
      patch "/api/v1/customers/#{@customer.id}/subscriptions/#{@subscription_1.id}", params: params

      expect(response).to be_successful
      expect(response.status).to eq(200)
      
      updated_subscription = JSON.parse(response.body, symbolize_names: true)
      
      expect(updated_subscription).to be_a Hash
      expect(updated_subscription[:data]).to be_a Hash
      
      new_status= updated_subscription[:data][:attributes][:status]
      
      expect(new_status).to eq('inactive')
      @subscription_1.reload
      expect(@subscription_1.status).to eq('inactive') 
    end

    it 'reinstates existing subscription' do 
      params = {
        status: 'active'
      }
      
      patch "/api/v1/customers/#{@customer.id}/subscriptions/#{@subscription_2.id}", params: params
      
      expect(response).to be_successful
      expect(response.status).to eq(200)

      updated_subscription = JSON.parse(response.body, symbolize_names: true)
      
      expect(updated_subscription).to be_a Hash
      expect(updated_subscription[:data]).to be_a Hash

      new_status = updated_subscription[:data][:attributes][:status]

      expect(new_status).to eq('active')
      @subscription_2.reload
      expect(@subscription_2.status).to eq('active') 
    end
  end

  describe 'sad path & edge case testing' do 
    it 'throws error if subscription does not exist' do 
      bad_id = @subscription_2.id + 5

      expect(Subscription.where(id: bad_id)).to be_empty

      patch "/api/v1/customers/#{@customer.id}/subscriptions/#{bad_id}"
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      error = JSON.parse(response.body, symbolize_names: true)
      
      check_hash_structure(error, :error, Hash)
      check_hash_structure(error[:error], :status, Integer)
      check_hash_structure(error[:error], :message, String)
      
      error_attributes = error[:error]
      expect(error_attributes[:status]).to eq(404)
      expect(error_attributes[:message]).to eq("Couldn't find Subscription with 'id'=#{bad_id}")
    end

    it 'throws error if customer does not exist for subscription' do
      bad_id = @customer.id + 30
      expect(Customer.where(id: bad_id)).to be_empty

      patch "/api/v1/customers/#{bad_id}/subscriptions/#{@subscription_1.id}"
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