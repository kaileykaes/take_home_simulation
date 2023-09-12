require 'rails_helper'

RSpec.describe 'Subscription Cancellation', type: :request do
  before(:each) do 
    tea_1 = create(:tea)
    tea_2 = create(:tea)
    tea_3 = create(:tea)

    @customer = create(:customer)
    @subscription_1 = create(:subscription, customer: @customer)
    @subscription_2 = create(:subscription, customer: @customer)
    
    create(:subscription_tea, subscription: @subscription_1, tea: tea_1)
    create(:subscription_tea, subscription: @subscription_1, tea: tea_2)
    create(:subscription_tea, subscription: @subscription_1, tea: tea_3)

    create(:subscription_tea, subscription: @subscription_2, tea: tea_1)
    create(:subscription_tea, subscription: @subscription_2, tea: tea_1)
    create(:subscription_tea, subscription: @subscription_2, tea: tea_2)
    create(:subscription_tea, subscription: @subscription_2, tea: tea_3)
  end

  describe 'happy path' do
    it 'cancels existing subscription' do 
      params = {
        status: 'inactive'
      }
  
      put "/api/v1/customers/#{@customer.id}/subscriptions/#{@subscription_1.id}", params: params
      
      expect(response).to be_successful
      expect(response.status).to eq(200)

      updated_subscription = JSON.parse(response.body, symbolize_names: true)
      
      expect(updated_subscription).to be_a Hash
      expect(updated_subscription[:data]).to be_a Hash

      new_status= updated_subscription[:data][:attributes][:status]

      expect(new_status).to eq('inactive')
      expect(@subscription_1.status).to eq('inactive') 
    end
  end
end