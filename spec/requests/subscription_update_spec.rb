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
end